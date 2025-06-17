variable "name" {
  description = "Name to use for Transit Gateway work"
}

variable "create_tgw" {
  description = "Boolean to set if this Transit Gateway should be created"
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

variable "dns_support" {
  description = "Enable DNS support on TGW Attachment"
}

variable "ipv6_support" {
  description = "Enable IPV6 support on TGW Attachment"
}

variable "appliance_mode_support" {
  description = "Enable appliance mode on TGW Attachment"
}
