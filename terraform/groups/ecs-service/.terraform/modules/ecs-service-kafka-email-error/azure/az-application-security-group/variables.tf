variable "resource_group_name" {
  type        = string
  description = "Default resource group name that the app security groups will be created in."
}

variable "asg_list" {
  type        = list(string)
  description = "A list of app security groups to create in the named Resource Group."
}

variable "tags" {
  description = "The tags to associate with your app security groups."
  type        = map(any)

  default = {
    tag = "value"
  }
}
