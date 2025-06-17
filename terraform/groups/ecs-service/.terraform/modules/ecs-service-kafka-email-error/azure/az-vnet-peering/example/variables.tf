variable "resource_group_name" {
  type        = string
  description = "Name to use when creating the resource group for azure services"
}

variable "location" {
  type        = string
  description = "Azure location to build resources in"
}

locals {
  default_tags = {
    Terraform = "True"
  }

  vnet_peer = {
    peer_name = "local-to-remote-vnet-peer"

    local = {
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      allow_gateway_transit        = false
      use_remote_gateways          = false // False because we are not creating a Gateway and it will fail if set to True
    }

    remote = {
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      allow_gateway_transit        = true
      use_remote_gateways          = false
    }
  }
}