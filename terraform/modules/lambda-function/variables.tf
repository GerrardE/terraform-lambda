
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
}

variable "apigw_statement_id" {
  type = string
  default = "AllowExecutionFromAPIGateway"
  description = "Api gateway statement id"
}

variable "source_arn" {
  description = "Source arn for the apigatewayv2 api gateway"
}
