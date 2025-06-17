variable "nsg_resource_group_name" {
  type        = string
  description = "Name of the Resource Group that the Network Security Group exists within"
}

variable "nsg_name" {
  type        = string
  description = "Name of the Network Security Group these rules will be added to"
}

variable "csv_file_location" {
  type        = string
  description = "The file location, local to the Terraform code, of the CSV file to use for rules"
}
