
# -----------------------------------------------------------------------------
# Variables: Main
# -----------------------------------------------------------------------------

variable "function_name" {
  description = "AWS lambda resource name"
}

variable "s3_bucket_id" {
  description = "AWS S3 resource id"
}

variable "s3_key" {
  description = "AWS S3 resource object key"
}

variable "handler" {
  description = "AWS lambda resource handler"
}

variable "iam_role" {
  description = "AWS lambda resource iam role"
}

variable "dependency" {
  description = "AWS lambda depends on for creation"
  default     = ""
}
