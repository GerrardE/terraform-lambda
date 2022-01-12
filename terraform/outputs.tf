output "function_name" {
  description = "Name of the Lambda function."

  value = module.fn.function_name
}

output "function_url" {
  description = "Invoke url of the Lambda function."

  value = "${aws_apigatewayv2_stage.lambda_gw_stg.invoke_url}"
}

output "artifact_store" {
  description = "S3 bucket ID"

  value = aws_s3_bucket.artifact_store.id
}

output "artifact" {
  description = "Key of the artifact"

  value = aws_s3_bucket_object.artifact.key
}
