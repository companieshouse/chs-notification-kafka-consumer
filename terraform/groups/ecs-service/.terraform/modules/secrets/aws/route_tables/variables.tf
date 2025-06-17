variable "vpcID" {
  type        = string
  description = "VPC Id for the VPC to create these subnets in"
}

variable "name" {
  type        = string
  description = "Name for the route table being created"
}

variable "route_list" {
  type        = list(any)
  description = ""
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "subnet_list" {
  type    = list(string)
  default = []
}