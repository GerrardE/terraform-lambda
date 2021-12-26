# -----------------------------------------------------------------------------
# Variables: Cloud Provider
# -----------------------------------------------------------------------------

variable "provider_region" {
  description = "AWS region"
  default = "us-east-1"
}

variable "provider_access_key" {
  description = "AWS access key"
}

variable "provider_secret_key" {
  description = "AWS secret key"
}

# -----------------------------------------------------------------------------
# Variables: Main
# -----------------------------------------------------------------------------

variable "namespace" {
  description = "AWS resource namespace/prefix"
  default = "prod"
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
variable "github_token" {
  type        = string
  description = "GitHub API or personal access token - see https://github.com/blog/1509-personal-api-tokens"
}

variable "github_user" {
  type        = string
  default     = "GerrardE"
  description = "GitHub username or organization is required"
}

variable "github_repo" {
  type        = string
  default     = "terraform-lambda"
  description = "GitHub source repository - must contain a Dockerfile and buildspec.yml in the base"
}

variable "github_branch" {
  type        = string
  default     = "main"
  description = "GitHub git repository branch - change triggers a new build"
}
