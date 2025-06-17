variable "name" {
  type        = string
  description = "A name to use as part of resource naming"
}

variable "enable_ssm" {
  description = "Enable SSM permissions to allow the instance to access SSM features such as session manager"
  default     = false
}

variable "ssm_kms_key" {
  description = "If enable_ssm=true, this will be used to allow the required kms permissions for SSM session encryption"
  type        = string
  default     = null
}

variable "custom_statements" {
  description = "The custom statement(s) to use as part of the policy document that is attached to the role, used when the existing statements do not cover the requirement"
  default     = null
}

variable "cw_log_group_arns" {
  type        = list(string)
  description = "A list of arns for log groups that an instance should have access to write logs to"
  default     = null
}

variable "instance_asg_arns" {
  type        = list(string)
  description = "A list of arns for autoscaling groups that an instance can make health updates to"
  default     = null
}

variable "kms_key_refs" {
  type        = list(string)
  description = "A list of reference (alias, key_id) for KMS keys that an instance should have access to make use of"
  default     = null
}

variable "s3_buckets_read" {
  type        = list(string)
  description = "List of S3 bucket names to grant Read access to"
  default     = []
}

variable "s3_buckets_write" {
  type        = list(string)
  description = "List of S3 bucket names to grant Write access to"
  default     = []
}

variable "s3_buckets_delete" {
  type        = list(string)
  description = "List of S3 bucket names to grant Delete access to"
  default     = []
}
