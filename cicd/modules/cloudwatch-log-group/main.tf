resource "aws_cloudwatch_log_group" "cwatch_logs" {
  name = var.log_name

  retention_in_days = 30
}
