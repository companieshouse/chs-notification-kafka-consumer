variable "cloudmanager_account_id" {
  description = "Account Id required for NetApp manager deploy"
  default     = null
}

variable "cloudmanager_refresh_token" {
  description = "Refresh token required for NetApp manager deploy from Cloud Manager portal"
}

variable "key_pair_name" {
  description = "Key pair name for the instance being created"
}

variable "cloudmanager_name" {
  description = "Name to use for resources created by Cloud Manager module"
}

