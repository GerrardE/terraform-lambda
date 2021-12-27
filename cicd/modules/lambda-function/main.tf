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
