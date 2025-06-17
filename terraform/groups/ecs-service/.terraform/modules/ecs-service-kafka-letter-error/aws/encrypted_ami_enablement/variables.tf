variable "aws_account" {
  description = "The name of the AWS account we're operating within"
  type        = string
}

variable "service_role_names" {
  default     = [
    "AWSServiceRoleForAutoScaling"
  ]
  description = "A list of IAM role names that KMS Grants will be configured for"
  type        = list(string)
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key to which access will be permitted by the KMS Grants"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:eu-west-[12]:[0-9]{12}:key\\/.*$", var.kms_key_arn))
    error_message = "kms_key_arn must be a valid KMS key ARN"
  }
}

variable "kms_key_region" {
  default     = "eu-west-2"
  description = "The region in which the key is provisioned"
  type        = string
}
