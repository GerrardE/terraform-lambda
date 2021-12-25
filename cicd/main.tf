provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

resource "aws_s3_bucket" "artifact_store" {
  bucket = "terraform_lambda_artifact_store"
  acl    = "private"

  tags = {
    Name        = "terraform_lambda_artifact_store"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_object" "artifact" {
  bucket = aws_s3_bucket.artifact_store.id

  key    = "terraform-lambda.zip"
  source = "${path.module}/build/terraform-lambda.zip"
}
