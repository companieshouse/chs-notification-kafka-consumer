provider "aws" {
}

data "aws_caller_identity" "current" {
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.name
  acl    = "private"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "aws_s3_bucket_policy" {
  source = "../"

  bucket_name           = module.s3_bucket.s3_bucket_id
  attach_policy         = true
  bucket_read_accounts  = [data.aws_caller_identity.current.account_id]
  bucket_write_accounts = [data.aws_caller_identity.current.account_id]

  s3_bucket_ownership_control = "BucketOwnerEnforced"

  // Depends on to avoid issues with conflicting operations adding bucket policy and public bock resources
  depends_on = [module.s3_bucket]
}
