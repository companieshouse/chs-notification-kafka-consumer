output "logging_bucket_arn" {
  value       = aws_s3_bucket.access_logs.arn
  description = "ARN of the s3 access logging bucket being created."
}

output "logging_bucket_id" {
  value       = aws_s3_bucket.access_logs.id
  description = "ID of the s3 access logging bucket being created."
}
