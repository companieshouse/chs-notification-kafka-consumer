variable "create_tgw" {
  description = "Boolean to create the Transit Gateway, if False will only allow joining of the named Transit Gateway rather thancreate one"
}

variable "share_tgw" {
  description = "Boolean to set if this Transit Gateway should be shared via AWS RAM"
}

variable "default_route_table_association" {
  description = "Boolean value, should this VPC be associated with the default route table"
}

variable "default_route_table_propagation" {
  description = "Boolean value, should this VPC propogate its CIDR range to the default route table"
}

variable "primary_dest_cidr" {
  description = "A cidr address to be applied to a route table"
}

variable "secondary_dest_cidr" {
  description = "A cidr address to be applied to a route table"
}