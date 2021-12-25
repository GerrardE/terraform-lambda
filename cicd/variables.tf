# -----------------------------------------------------------------------------
# Variables: Main
# -----------------------------------------------------------------------------

variable "namespace" {
  description = "AWS resource namespace/prefix"
  default = "terraform-lambda"
}

variable "region" {
  description = "AWS region"
  default = "us-east-1"
}

variable "resource_tag_name" {
  description = "Resource tag name for cost tracking"
  default = "terraform-lambda"
}

# -----------------------------------------------------------------------------
# Variables: CodeBuild
# -----------------------------------------------------------------------------
variable "build_provider" {
  type        = string
  default     = "CodeBuild"
  description = "Platform on which we are running builds"
}

variable "build_image" {
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
  description = "Docker image for build environment"
}

variable "build_compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "Instance type of the build instance"
}

variable "build_timeout" {
  type = number
  default     = 5
  description = "AWS Codebuild timeout in minutes, from 5 to 480 (8 hours)"
}

# -----------------------------------------------------------------------------
# Variables: CodePipeline
# -----------------------------------------------------------------------------
variable "poll_source_changes" {
  type        = string
  default     = "false"
  description = "Check periodically and run pipeline if there are changes"
}

# -----------------------------------------------------------------------------
# Variables: Github
# -----------------------------------------------------------------------------
variable "github_oauth_token" {
  type        = string
  description = "Github OAuth token"
}

variable "github_user" {
  type        = string
  description = "Github username"
}

variable "github_repo" {
  type        = string
  description = "Github repository name"
}

variable "github_branch" {
  type        = string
  description = "Github branch name"
  default     = "main"
}

# -----------------------------------------------------------------------------
# Variables: CloudWatch
# -----------------------------------------------------------------------------
