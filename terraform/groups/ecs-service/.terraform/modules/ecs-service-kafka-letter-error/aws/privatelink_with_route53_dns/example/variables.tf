variable "name" {
  type        = string
  description = "Name value for VPC"
}

variable "service_name" {
  type        = string
  description = "Name for the endpoint service"
}

variable "region" {
  type        = string
  description = "Region to build example"
}

variable "az_number" {
  # Assign a number to each AZ letter used in our configuration
  default = {
    a = 1
    b = 2
    c = 3
    d = 4
    e = 5
    f = 6
  }
}