variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy resoures"
}

variable "location" {
  type        = string
  description = "location to deploy example infrastructure"
}

variable "enable_active_active" {
  type        = bool
  description = "Enable Active:Active mode on VPN"
  default     = false
}