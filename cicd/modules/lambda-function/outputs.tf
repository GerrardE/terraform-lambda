# Output variable definitions

output "function_name" {
  description = "AWS lambda fn name"
  value       = aws_lambda_function.lambda_fn.function_name
}

output "function_handler" {
  description = "AWS lambda fn handler"
  value       = aws_lambda_function.lambda_fn.handler
}

output "invoke_arn" {
  description = "AWS lambda fn invoke arn"
  value       = aws_lambda_function.lambda_fn.arn
}
