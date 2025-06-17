variable "description" {
  type        = string
  description = "Description field for the CMK"
}

variable "deletion_window_in_days" {
  type        = number
  default     = 10
  description = "Duration in days after which the key is deleted after destruction of the resource"
}

variable "enable_key_rotation" {
  type        = bool
  default     = true
  description = "Specifies whether key rotation is enabled"
}

variable "kms_key_alias" {
  type        = string
  default     = null
  description = "The display name of the key"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "is_enabled" {
  description = "(Optional) Specifies whether the key is enabled. Defaults to true."
  type        = bool
  default     = true
}

variable "kmsadmin_principals" {
  type        = list(string)
  default     = null
  description = "KMS Key Admin IAM Principals, will be specifically granted full access (including key deletion) to this key. e.g. `user/username`, `role/rolename`"
}

variable "kmsuser_principals" {
  type        = list(string)
  default     = null
  description = "KMS Key User IAM Principals, will be specifically granted usage of this key"
}

variable "key_usage_foreign_account_ids" {
  type        = list(string)
  description = "List of remote account ID's to delegate access to this key to"
  default     = null
}

variable "key_grant_foreign_account_ids" {
  type        = list(string)
  description = "List of remote account ID's to allow to create grants on this key"
  default     = null
}

variable "service_linked_role_principals" {
  type        = list(string)
  description = "List of service linked role principles in the local account to allow usage and delegation of the key, e.g. `autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling`"
  default     = null
}

variable "service_principal_names" {
  type        = list(string)
  description = "List of AWS service names allowed to use this key"
  default     = null
}

variable "service_principal_names_non_region" {
  type        = list(string)
  description = "List of AWS service names allowed to use this key - without region"
  default     = null
}

variable "cloudtrail_account_ids" {
  type        = list(string)
  description = "List of account IDs to allow Cloudtrail to use this key for encrypt and describe operations."
  default     = null
}
