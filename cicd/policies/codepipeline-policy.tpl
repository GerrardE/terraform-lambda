{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:List*",
        "s3:PutObject"
      ],
      "Resource": [
        "${s3_bucket_arn}",
        "${s3_bucket_arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
          "codebuild:BatchGetBuilds", 
          "codebuild:StartBuild"
        ],
      "Resource": "${codebuild_project_arn}"
    },
    {
        "Effect": "Allow",
        "Action": [
            "codestar-connections:PassConnection",
            "codestar-connections:UseConnection"
        ],
        "Resource": [
          "${codestar_connection_arn}",
          "${codestar_connection_arn}/*"
        ],
        "Condition": {"ForAllValues:StringEquals": {"codestar-connections:PassedToService": "codepipeline.amazonaws.com"}}
    }
  ]
}
