
# -----------------------------------------------------------------------------
# Resource: Lambda function
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "lambda_fn" {
  function_name = var.function_name

  s3_bucket = var.s3_bucket_id
  s3_key    = var.s3_key

  runtime = "nodejs12.x"
  handler = var.handler

  role = var.iam_role

  depends_on = [
    var.dependency,
  ]
}


# -----------------------------------------------------------------------------
# Resource: Lambda function logs
# -----------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "cwatch_logs" {
  name = "/aws/lambda/${aws_lambda_function.lambda_fn.function_name}"

  retention_in_days = 30
}

# -----------------------------------------------------------------------------
# Resource: Api Exec Permissions
# -----------------------------------------------------------------------------

module "api_gw_perm" {
  source  = "Cloud-42/lambda-permission/aws"
  version = "2.0.0"

  function_name = aws_lambda_function.lambda_fn.function_name
  statement_id  = var.apigw_statement_id
  source_arn    = var.source_arn
}
