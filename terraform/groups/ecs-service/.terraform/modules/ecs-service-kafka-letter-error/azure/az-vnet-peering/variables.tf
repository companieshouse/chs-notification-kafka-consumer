variable "vnet_peer_config" {
  type = object({
    peer_name = string,
    local = object({
      allow_virtual_network_access = bool,
      allow_forwarded_traffic      = bool,
      allow_gateway_transit        = bool,
      use_remote_gateways          = bool
    }),
    remote = object({
      allow_virtual_network_access = bool,
      allow_forwarded_traffic      = bool,
      allow_gateway_transit        = bool,
      use_remote_gateways          = bool
    })
  })
  description = "An object variable that consists of the relevant information to create a virtual network peering connection"
}

variable "local_resource_group_name" {
  type        = string
  description = "The resource group name this virtual network will be created in"
}

variable "local_virtual_network_name" {
  type        = string
  description = "The virtual network name this virtual network gateway will be created in"
}

variable "remote_resource_group_name" {
  type        = string
  description = "The resource group name this virtual network will be created in"
}

variable "remote_virtual_network_name" {
  type        = string
  description = "The virtual network name this virtual network gateway will be created in"
}

variable "tags" {
  type        = map(any)
  description = "The tags to be applied to this resource"
  default = {
    Terraform = "True"
  }
}

