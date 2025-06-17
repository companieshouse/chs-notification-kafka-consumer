variable "vpc_id" {
  type        = string
  description = "VPC Id for the VPC to create these subnets in"
}

variable "networks" {
  type = list(object({
    name     = string
    new_bits = number
  }))
  description = "A list of objects describing requested subnetwork prefixes. new_bits is the number of additional network prefix bits to add, in addition to the existing prefix on base_cidr_block."
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}