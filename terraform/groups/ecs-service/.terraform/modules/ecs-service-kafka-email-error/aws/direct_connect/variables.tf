variable "name" {
  type        = string
  description = "Unique identifier for resource naming"
}

variable "transit_gateway_id" {
  type        = string
  default     = null
  description = "ID of the Transit Gateway to attach Direct Connect to."
}

variable "allowed_prefixes" {
  type        = list(string)
  default     = null
  description = "(Optional) VPC prefixes (CIDRs) to advertise to the Direct Connect gateway."
}

variable "aws_dx_connections" {
  type        = list(map(any))
  default     = []
  description = "A list of maps, with each map containing the required information on a existing provisioned hosted Direct Connect connection."
}

variable "address_family" {
  type        = string
  default     = "ipv4"
  description = ""
}

variable "dx_transit_vif_mtu" {
  type        = number
  default     = 1500
  description = "The MTU for virtual transit interfaces, can be either 1500 or 8500"
}

variable "amazon_side_asn" {
  type        = number
  description = "The ASN to be configured on the Amazon side of the connection."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to apply to all taggable resources created by this module."
}
