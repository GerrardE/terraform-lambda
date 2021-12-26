terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.48.0"
    }
  }

  required_version = "~> 1.0"
}

locals {
  resource_name = "${var.namespace}-${var.resource_tag_name}"
}

provider "aws" {
  region     = var.provider_region
  access_key = var.provider_access_key
  secret_key = var.provider_secret_key
}

# -----------------------------------------------------------------------------
# Resources: Random string
# -----------------------------------------------------------------------------
resource "random_string" "postfix" {
  length  = 6
  number  = false
  upper   = false
  special = false
  lower   = true
}

# -----------------------------------------------------------------------------
# Resources: S3
# -----------------------------------------------------------------------------
resource "aws_s3_bucket" "artifact_store" {
  bucket        = "${local.resource_name}-artifact-store-${random_string.postfix.result}"
  acl           = "private"
  force_destroy = true

  tags = {
    Environment = var.namespace
    Name        = var.resource_tag_name
  }
}

resource "aws_s3_bucket_object" "artifact" {
  bucket = aws_s3_bucket.artifact_store.id

  key    = "${var.resource_tag_name}.zip"
  source = "../build/terraform-lambda.zip"

  depends_on = [
    aws_s3_bucket.artifact_store,
  ]
}
