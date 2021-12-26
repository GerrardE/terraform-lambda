# -----------------------------------------------------------------------------
# Resources: CodeBuild
# # NB: cb - codebuild, rl - role, rp - role policy
# -----------------------------------------------------------------------------
resource "aws_iam_role" "terraform_lambda_cb_rl" {
  name = "${local.resource_name}-codebuild-role"

  assume_role_policy = file("${path.module}/policies/codebuild-assume-role.json")
}

data "template_file" "codebuild-policy-template" {
    template = file("${path.module}/policies/codebuild-policy.tpl")

    vars = {
        s3_bucket_arn = aws_s3_bucket.artifact_store.arn
    }
}

resource "aws_iam_role_policy" "terraform_lambda_cb_rp" {
  role = aws_iam_role.terraform_lambda_cb_rl.name

  policy = data.template_file.codebuild-policy-template.rendered
}

resource "aws_codebuild_project" "terraform_lambda_cb_proj" {
  name          = "${local.resource_name}-codebuild"
  description   = "${local.resource_name}-codebuild-project"
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.terraform_lambda_cb_rl.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.build_compute_type
    image                       = var.build_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "S3-BUCKET"
      value = aws_s3_bucket.artifact_store.id
    }
    
    environment_variable {
      name  = "S3-BUCKET-KEY"
      value = aws_s3_bucket_object.artifact.key
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }
  }

  source {
    type            = "CODEPIPELINE"
    location        = "https://github.com/GerrardE/terraform-lambda.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "main"

  tags = {
    Environment = var.namespace
    Name        = var.resource_tag_name
  }
}

# -----------------------------------------------------------------------------
# Resources: CodePipeline
# NB: cp - codepipeline, rl - role, rp - role policy
# -----------------------------------------------------------------------------
resource "aws_iam_role" "terraform_lambda_cp_rl" {
  name = "${local.resource_name}-codepipeline-role"

  assume_role_policy = file("${path.module}/policies/codepipeline-assume-role.json")
}

data "template_file" "codepipeline-policy-template" {
    template = file("${path.module}/policies/codepipeline-policy.tpl")

    vars = {
        s3_bucket_arn = aws_s3_bucket.artifact_store.arn
        codebuild_project_arn = aws_codebuild_project.terraform_lambda_cb_proj.arn
        codestar_connection_arn = aws_codestarconnections_connection.connect_repo.arn
    }
}

resource "aws_iam_role_policy" "terraform_lambda_cp_rp" {
  name = "${local.resource_name}-codepipeline-policy"
  role = aws_iam_role.terraform_lambda_cp_rl.id

  policy = data.template_file.codepipeline-policy-template.rendered
}

resource "aws_codestarconnections_connection" "connect_repo" {
  name          = "${local.resource_name}-connection"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "terraform_lambda_cp_proj" {
  name     = "${local.resource_name}-codepipeline"
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
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.connect_repo.arn
        FullRepositoryId = "${var.github_user}/${var.github_repo}"
        BranchName       = var.github_branch
      }
    }
  }

  stage {
    name = "Build-Deploy"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = var.build_provider
      input_artifacts  = ["source_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.terraform_lambda_cb_proj.name
      }
    }
  }

  tags = {
    Environment = var.namespace
    Name        = var.resource_tag_name
  }
}
