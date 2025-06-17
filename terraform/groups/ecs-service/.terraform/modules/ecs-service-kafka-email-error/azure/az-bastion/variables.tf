variable "resource_group_name" {
  type        = string
  description = "The resource group name this Azure Bastion will be created in"
}

variable "location" {
  type        = string
  description = "Azure Region to deploy the Azure Bastion components"
}

variable "subnet_id" {
  type        = string
  description = "The subnetId for the AzureBastionSubnet the Bastion will be created in"
}

variable "bastion_name" {
  type        = string
  description = "The name for Bastion host"
  default     = "bastion-001"
}

variable "publicip_name" {
  type        = string
  description = "The name for the Public IP for the Bastion"
  default     = "pip-bastion-001"
}

variable "nsg_name" {
  type        = string
  description = "The name to give to the Azure Bastion Network Security Group"
  default     = "nsg-bastion-001"
}

variable "tags" {
  type        = map
  description = "The tags to be applied to this resource"
  default = {
    terraform = "true"
  }
}