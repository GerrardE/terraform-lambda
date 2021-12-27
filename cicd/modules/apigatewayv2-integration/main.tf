resource "aws_apigatewayv2_integration" "function_integrtn" {
  api_id = var.api_id

  integration_uri    = var.integration_uri
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}
