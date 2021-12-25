
resource "aws_iam_role" "terraform_lambda_cb_rl" {
  name = "terraform-lambda-codebuild-role"

  assume_role_policy = <<EOF
                        {
                            "Version": "2012-10-17",
                            "Statement": [
                                {
                                "Effect": "Allow",
                                "Principal": {
                                    "Service": "codebuild.amazonaws.com"
                                },
                                "Action": "sts:AssumeRole"
                                }
                            ]
                        }
                        EOF
}

resource "aws_iam_role_policy" "terraform_lambda_cb_rp" {
  role = aws_iam_role.terraform_lambda_rl.name

  policy = <<POLICY
            {
                "Version": "2012-10-17",
                "Statement": [
                    {
                      "Effect": "Allow",
                      "Resource": [
                        "*"
                      ],
                      "Action": [
                        "logs:CreateLogGroup",
                        "logs:CreateLogStream",
                        "logs:PutLogEvents"
                      ]
                    },
                    {
                        "Effect": "Allow",
                        "Action": [
                            "s3:PutObject",
                            "s3:PutObjectAcl"
                            "s3:GetObject",
                            "s3:GetObjectAcl",
                            "s3:GetObjectVersion",
                            "s3:GetBucketVersioning"
                        ],
                        "Resource": [
                            "${aws_s3_bucket.artifact_store.arn}/*"
                        ]
                    }
                ]
            }
            POLICY
}

resource "aws_codebuild_project" "terraform_lambda_cb_proj" {
  name          = "terraform-lambda-codebuild-project"
  description   = "Build and deploy lamda to s3-bucket"
  build_timeout = "5"
  service_role  = aws_iam_role.terraform_lambda_rl.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.artifact_store.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/GerrardE/terraform-lambda.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "main"

  tags = {
    Environment = "dev"
  }
}

resource "aws_iam_role" "terraform_lambda_cp_rl" {
  name = "terraform-lambda-codepipeline-role"

  assume_role_policy = <<EOF
                            {
                                "Version": "2012-10-17",
                                "Statement": [
                                    {
                                    "Effect": "Allow",
                                    "Principal": {
                                        "Service": "codepipeline.amazonaws.com"
                                    },
                                    "Action": "sts:AssumeRole"
                                    }
                                ]
                            }
                        EOF
}

resource "aws_iam_role_policy" "terraform_lambda_cp_rp" {
  name = "terraform-lambda-codepipeline-policy"
  role = aws_iam_role.terraform_lambda_cp_rl.id

  policy = <<EOF
            {
                "Version": "2012-10-17",
                "Statement": [
                    {
                    "Effect":"Allow",
                    "Action": [
                        "s3:GetObject",
                        "s3:GetObjectVersion",
                        "s3:GetBucketVersioning",
                        "s3:PutObjectAcl",
                        "s3:PutObject"
                    ],
                    "Resource": [
                        "${aws_s3_bucket.artifact_store.arn}/*"
                    ]
                    },
                    {
                    "Effect": "Allow",
                    "Action": [
                        "codebuild:BatchGetBuilds",
                        "codebuild:StartBuild"
                    ],
                    "Resource": "*"
                    }
                ]
            }
            EOF
}

resource "aws_codepipeline" "terraform_lambda_cp_proj" {
  name     = "terraform-lambda-codepipeline"
  role_arn = aws_iam_role.terraform_lambda_cp_rl.arn

  artifact_store {
    location = aws_s3_bucket.artifact_store.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "Github"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_user
        Repo       = var.github_repo
        Branch     = var.github_branch
        OAuthToken = var.github_oauth_token
      }
    }
  }

  stage {
    name = "Build & Deploy"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = var.build_provider
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.terraform_lambda_cb_proj.name
      }
    }
  }
}
