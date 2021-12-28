
# -----------------------------------------------------------------------------
# Resource: Lambda function and resources required to expose it to the web
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

resource "aws_cloudwatch_log_group" "cwatch_logs" {
  name = "/aws/lambda/${aws_lambda_function.lambda_fn.function_name}"

  retention_in_days = 30
}

# -----------------------------------------------------------------------------
# Resource: Api Gateway Integration
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_integration" "function_integrtn" {
  api_id = var.api_id

  integration_uri    = aws_lambda_function.lambda_fn.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

# -----------------------------------------------------------------------------
# Resource: Api Gateway Integration Routes
# -----------------------------------------------------------------------------

resource "aws_apigatewayv2_route" "fn_rte" {
  api_id = var.api_id

  route_key = var.route_key
  target    = "integrations/${aws_apigatewayv2_integration.function_integrtn.id}"
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
