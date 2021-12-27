output "function_1_name" {
  description = "Name of the Lambda function."

  value = module.fn_1.function_name
}

output "function_1_url" {
  description = "Invoke url of the Lambda function."

  value = "${aws_apigatewayv2_stage.lambda_gw_stg.invoke_url}/${module.fn_1.function_name}"
}

output "function_2_name" {
  description = "Name of the Lambda function."

  value = module.fn_2.function_name
}

output "function_2_url" {
  description = "Invoke url of the Lambda function."

  value = "${aws_apigatewayv2_stage.lambda_gw_stg.invoke_url}/${module.fn_2.function_name}"
}

output "artifact_store" {
  description = "S3 bucket ID"

  value = aws_s3_bucket.artifact_store.id
}

output "artifact" {
  description = "Key of the artifact"

  value = aws_s3_bucket_object.artifact.key
}
