variable "resource_group_name" {
  type        = string
  description = "Default resource group name that the network will be created in."
}

variable "route_table_name" {
  type        = string
  description = "The name of the RouteTable being created."
  default     = "routetable"
}

variable "disable_bgp_route_propagation" {
  type        = bool
  description = "Boolean flag which controls propagation of routes learned by BGP on that route table. True means disable."
  default     = "true"
}

variable "route_list" {
  type        = list(any)
  description = "A list of routes to create in the Route Table."
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(any)

  default = {
    tag = "value"
  }
}
