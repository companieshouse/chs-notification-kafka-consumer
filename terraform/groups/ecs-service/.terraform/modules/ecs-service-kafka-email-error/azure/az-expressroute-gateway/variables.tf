variable "resource_group_name" {
  type        = string
  description = "The resource group name this Express Route will be created in"
}

variable "location" {
  type        = string
  description = "Azure Region to deploy the express route components"
}

variable "subnet_id" {
  type        = string
  description = "The subnetId for the GatewaySubnet the ExpressRoute Gateway will be created in"
}

variable "name" {
  type        = string
  description = "The name to use for Express Route resources created (will be joined with other values to make names more useful)"
}

variable "create_gateway" {
  type        = bool
  description = "A True/False value to allow for option to build or not build the Express route gateway"
  default     = false
}

variable "expressroute_public_ip_sku" {
  type        = string
  description = "SKU to use for the public IP, Basic or Standard"
  default     = "Basic"
}

variable "expressroute_vpn_sku" {
  type        = string
  description = "Configuration of the size and capacity of the virtual network gateway. Valid options for Express Route are Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ."
  default     = "Standard"
}

variable "create_circuit" {
  type        = bool
  description = "a True/False value to allow for option to build or not build the Express route Circuit"
  default     = false
}

variable "circuit_service_provider" {
  type        = string
  description = "The name of the Express Route Service Provider."
  default     = null
}

variable "circuit_peering_location" {
  type        = string
  description = "The name of the peering location and not the Azure resource location. Depends on the provider chosen and its available locations"
  default     = null
}

variable "circuit_bandwidth_in_mbps" {
  type        = number
  description = "A number for the bandwith required for this Express Route Circuit. *Once you increase your bandwidth, you will not be able to decrease it to its previous value*"
  default     = 50
}

variable "circuit_sku_tier" {
  type        = string
  description = "The service tier. Possible values are Basic, Local, Standard or Premium."
  default     = "Basic"
}

variable "circuit_sku_family" {
  type        = string
  description = "The billing mode for bandwidth. Possible values are MeteredData or UnlimitedData. *You can migrate from MeteredData to UnlimitedData, but not the other way around.*"
  default     = "MeteredData"
}

variable "circuit_peer_asn" {
  type        = string
  description = "ASN Number for the peering, not the customer ASN"
  default     = null
}

variable "circuit_peer_primary_address_prefix" {
  type        = string
  description = "Subnet range to be used as the primary prefix in the circuit peering"
  default     = null
}

variable "circuit_peer_secondary_address_prefix" {
  type        = string
  description = "Subnet range to be used as the secondary prefix in the circuit peering"
  default     = null
}

variable "circuit_vlanid" {
  type        = string
  description = "The Vlan Id that relates to the provisioned circuits from the provider"
  default     = null
}

variable "circuit_shared_key" {
  type        = string
  description = "An optional Shared Key that can be used to setup the circuit and peering"
  default     = null
}

variable "existing_vgw_id" {
  type        = string
  description = "The Id for an existing Gateway to connect the circuit to if built."
  default     = null
}

variable "gateway_connection_enable_bgp" {
  type        = bool
  description = "Boolean to enable BGP on the Express Route connection"
  default     = false
}

variable "tags" {
  type        = map(any)
  description = "The tags to be applied to this resource"
  default = {
    Terraform = "True"
  }
}
