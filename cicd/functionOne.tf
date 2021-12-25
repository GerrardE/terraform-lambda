# -----------------------------------------------------------------------------
# Resource: Lambda Function
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "fn_1" {
  function_name = "createEvent"

  s3_bucket = aws_s3_bucket.artifact_store.id
  s3_key    = aws_s3_bucket_object.artifact.key

  runtime = "nodejs12.x"
  handler = "index.createEvent"

  #   source_code_hash = data.archive_file.aws_s3_bucket_object.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "fn_1_logs" {
  name = "/aws/lambda/${aws_lambda_function.fn_1.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "terraform_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda-policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# -----------------------------------------------------------------------------
# Resource: Api Gateway
# -----------------------------------------------------------------------------

resource "aws_apigatewayv2_api" "lambda_gw" {
  name          = "terraform_lambda_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda_gw_stg" {
  api_id = aws_apigatewayv2_api.lambda_gw.id

  name        = "lambda_gw_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "fn_1_integrtn" {
  api_id = aws_apigatewayv2_api.lambda_gw.id

  integration_uri    = aws_lambda_function.fn_1.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "fn_1_rte" {
  api_id = aws_apigatewayv2_api.lambda_gw.id

  route_key = "POST /createEvent"
  target    = "integrations/${aws_apigatewayv2_integration.fn_1_integrtn.id}"
}

resource "aws_cloudwatch_log_group" "api_gw_lg" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda_gw.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw_perm" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fn_1.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda_gw.execution_arn}/*/*"
}
