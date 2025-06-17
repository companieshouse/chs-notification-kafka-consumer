variable "cloudwatch_logging" {
  description = "Enable or Disable CloudWatch Logging for CloudTrail"
  default     = false
  type        = bool
}

variable "encrypt_trail" {
  description = "True to enable KMS encryption on Cloudtrail using the KMS key provided in var.kms_key"
  default     = true
  type        = bool
}

variable "kms_key" {
  description = "Provide a KMS key identifier to setup encryption for CloudTrail logs."
  default     = null
  type        = string
}

variable "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch Log Group that receives CloudTrail events."
  default     = "cloudtrail-events"
  type        = string
}

variable "enabled" {
  description = "Enables logging for the trail. Defaults to true. Setting this to false will pause logging."
  default     = true
  type        = bool
}

variable "log_retention_days" {
  description = "Number of days to keep AWS logs around in specific log group."
  default     = 90
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the AWS S3 bucket."
  type        = string
}

variable "org_trail" {
  description = "Whether or not this is an organization trail. Only valid in master account."
  default     = "false"
  type        = string
}

variable "key_deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource, must be 7-30 days.  Default 30 days."
  default     = 30
  type        = string
}

variable "trail_name" {
  description = "Name for the Cloudtrail"
  default     = "cloudtrail"
  type        = string
}

variable "s3_key_prefix" {
  description = "S3 key prefix for CloudTrail logs"
  default     = "cloudtrail"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to the resources created in this module"
  default = {
    "Terraform" = "True"
  }
  type = map(any)
}

variable "event_selector" {
  type = list(object({
    include_management_events = bool
    read_write_type           = string

    data_resource = list(object({
      type   = string
      values = list(string)
    }))
  }))

  description = "Specifies an event selector for enabling data event logging."
  default     = []
}
