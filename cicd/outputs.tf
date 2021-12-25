output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.fn_1.function_name
}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.lambda_gw_stg.invoke_url
}
