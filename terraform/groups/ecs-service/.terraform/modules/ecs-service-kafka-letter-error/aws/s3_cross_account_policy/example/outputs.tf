output "s3_bucket_policy_document" {
  value = module.aws_s3_bucket_policy.s3_bucket_policy_document
}

output "s3_bucket_name" {
  value = module.s3_bucket.s3_bucket_id
}
