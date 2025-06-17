variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket. Used for generating policy document resources and optionally for attachment of the policy."
}

variable "attach_policy" {
  type        = bool
  default     = true
  description = "True to attach the generated policy to the provided S3 Bucket, false to just output the bucket policy document to be used elsewhere."
}

variable "bucket_read_accounts" {
  type        = list(string)
  description = "List of account IDs to delegate read access to in the bucket policy."
  default     = []
}

variable "bucket_write_accounts" {
  type        = list(string)
  description = "List of account IDs to delegate write access to in the bucket policy."
  default     = []
}

variable "bucket_write_accounts_no_acl" {
  type        = list(string)
  description = "List of account IDs to delegate write access to in the bucket policy without the bucket-owner-full-control ACL enforced."
  default     = []
}

variable "bucket_delete_accounts" {
  type        = list(string)
  description = "List of account IDs to delegate delete object access to in the bucket policy."
  default     = []
}

variable "s3_bucket_allow_ssl_only" {
  type        = bool
  description = "Adds policy block that will block any non-SSL requests to the S3 bucket."
  default     = true
}

variable "custom_statements" {
  type        = any
  description = "Allows custom statements to be added to the policy"
  default     = null
}

variable "s3_bucket_ownership_control" {
  type        = string
  description = "S3 bucket ownership controls to apply to the bucket. Valid values: BucketOwnerPreferred, ObjectWriter or BucketOwnerEnforced. Default value: BucketOwnerPreferred"
  default     = "BucketOwnerPreferred"
  validation {
    condition     = contains(["BucketOwnerPreferred", "ObjectWriter", "BucketOwnerEnforced"], var.s3_bucket_ownership_control)
    error_message = "Valid values for s3_bucket_ownership_control: BucketOwnerPreferred, ObjectWriter or BucketOwnerEnforced."
  }
}
