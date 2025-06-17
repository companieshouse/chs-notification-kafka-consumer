variable "name" {
  type        = string
  description = "A name to give to the Log Analytics workspace. Workspace name should include 4-63 letters, digits or '-'. The '-' shouldn't be the first or the last symbol"
}

variable "sku" {
  type        = string
  description = "Specifies the Sku (pricing tier) of the Log Analytics Workspace. Allowed values are: PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018"
}

variable "retention_in_days" {
  type        = string
  description = "The workspace data retention in days. Possible values range between 30 and 730"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name this NSG will be created in"
}

variable "tags" {
  type        = map(any)
  description = "The tags to be applied to this resource"
  default = {
    Terraform = "True"
  }
}