variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy resoures"
}

variable "location" {
  type        = string
  description = "location to deploy example infrastructure"
}

variable "win_vm_name" {
  type        = string
  description = "Name to be given to the Windows Virtual Machine"
}

variable "lin_vm_name" {
  type        = string
  description = "Name to be given to the Linux Virtual Machine"
}

variable "admin_pass" {
  type        = string
  description = "Password to use for the admin user"
}
