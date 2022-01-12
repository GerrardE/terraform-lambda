output "arn" {
  description = "Cloudwatch arn"
  value       = aws_cloudwatch_log_group.cwatch_logs.arn
}
