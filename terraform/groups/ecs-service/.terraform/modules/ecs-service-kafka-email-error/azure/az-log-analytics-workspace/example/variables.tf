variable "resource_group_name" {
  type        = string
  description = "The resource group name this NSG will be created in"
}

variable "location" {
  type        = string
  description = "Azure location to deploy resources"
}
