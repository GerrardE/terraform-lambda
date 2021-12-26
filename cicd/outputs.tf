output "function_1_url" {
  description = "Name of the Lambda function."

  value = "${aws_apigatewayv2_stage.lambda_gw_stg.invoke_url}/${aws_lambda_function.fn_1.function_name}"
}

output "function_2_url" {
  description = "Name of the Lambda function."

  value = "${aws_apigatewayv2_stage.lambda_gw_stg.invoke_url}/${aws_lambda_function.fn_2.function_name}"
}
