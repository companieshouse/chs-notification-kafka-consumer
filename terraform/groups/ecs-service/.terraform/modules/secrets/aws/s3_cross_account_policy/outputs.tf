output "s3_bucket_policy_document" {
  value       = data.aws_iam_policy_document.this.json
  description = "The IAM policy document created by this module"
}
