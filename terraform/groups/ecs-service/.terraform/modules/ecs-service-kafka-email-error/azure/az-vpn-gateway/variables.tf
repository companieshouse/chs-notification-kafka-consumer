variable "resource_group_name" {
  type        = string
  description = "The resource group name this Express Route will be created in"
}

variable "virtual_network_name" {
  type        = string
  description = "The virtual network name this Express Route will be created in"
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

variable "vpn_public_ip_sku" {
  type        = string
  description = "SKU to use for the public IP, Basic or Standard"
  default     = "Basic"
}

variable "vpn_sku" {
  type        = string
  description = "(Required) Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, Standard, HighPerformance, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ and depend on the type, vpn_type and generation arguments. A PolicyBased gateway only supports the Basic sku."
  default     = "Standard"
}

variable "vpn_enable_active_active" {
  type        = bool
  description = "a True/False value to enable Active:Active mode for the VPN"
  default     = false
}

variable "vpn_enable_bgp" {
  type        = bool
  description = "a True/False value to enable BGP for the VPN"
  default     = false
}

variable "vpn_bgp_asn" {
  type        = string
  description = "(Optional) The Autonomous System Number (ASN) to use as part of the BGP."
  default     = null
}

variable "vpn_bgp_peering_addresses" {
  type        = list(any)
  description = "Optional) A list of peering_addresses as defined below. Only one peering_addresses block can be specified except when active_active of this Virtual Network Gateway is true."
  default     = null
}

variable "vpn_bgp_peer_weight" {
  type        = number
  description = "(Optional) The weight added to routes which have been learned through BGP peering. Valid values can be between 0 and 100."
  default     = null
}

variable "enable_client_connections" {
  type        = bool
  description = "a True/False value to enable client connections for this VPN, allows for point to site connectivity"
  default     = false
}

variable "vpn_client_address_space" {
  type        = list(any)
  description = "(Required if client connections enabled) The address space out of which ip addresses for vpn clients will be taken. You can provide more than one address space, e.g. in CIDR notation."
  default     = null
}

variable "vpn_client_aad_tenant" {
  type        = string
  description = "(Optional) AzureAD Tenant URL This setting is incompatible with the use of root_certificate and revoked_certificate, radius_server_address, and radius_server_secret."
  default     = null
}

variable "vpn_client_aad_audience" {
  type        = string
  description = "(Optional) The client id of the Azure VPN application. See https://docs.microsoft.com/en-gb/azure/vpn-gateway/openvpn-azure-ad-tenant-multi-app for values. This setting is incompatible with the use of root_certificate and revoked_certificate, radius_server_address, and radius_server_secret."
  default     = null
}

variable "vpn_client_aad_issuer" {
  type        = string
  description = "(Optional) The STS url for your tenant This setting is incompatible with the use of root_certificate and revoked_certificate, radius_server_address, and radius_server_secret."
  default     = null
}

variable "vpn_client_radius_server_address" {
  type        = string
  description = "(Optional) The address of the Radius server. This setting is incompatible with the use of aad_tenant, aad_audience, aad_issuer, root_certificate and revoked_certificate."
  default     = null
}

variable "vpn_client_radius_server_secret" {
  type        = string
  description = "(Optional) The secret used by the Radius server. This setting is incompatible with the use of aad_tenant, aad_audience, aad_issuer, root_certificate and revoked_certificate."
  default     = null
}

variable "vpn_client_protocols" {
  type        = list(any)
  description = "(Optional) List of the protocols supported by the vpn client. The supported values are SSTP, IkeV2 and OpenVPN. Values SSTP and IkeV2 are incompatible with the use of aad_tenant, aad_audience and aad_issuer."
  default     = null
}

variable "root_certificates" {
  type        = list(any)
  description = "(Optional) These root certificates are used to sign the client certificate used by the VPN clients to connect to the gateway. This setting is incompatible with the use of aad_tenant, aad_audience, aad_issuer, radius_server_address, and radius_server_secret. Each certificate should be listed as: [{ name = <name>, cert_data = <The public certificate of the root certificate authority. The certificate must be provided in Base-64 encoded X.509 format (PEM). In particular, this argument must not include the -----BEGIN CERTIFICATE----- or -----END CERTIFICATE----- markers.> }]"
  default     = null
}

variable "revoked_certificate" {
  type        = list(any)
  description = "(Optional) Root certificates to revoke. This setting is incompatible with the use of aad_tenant, aad_audience, aad_issuer, radius_server_address, and radius_server_secret. Each certificate should be listed as: [{ name = <name>, thumbprint = <The SHA1 thumbprint of the certificate to be revoked.>}]"
  default     = null
}

variable "tags" {
  type        = map(any)
  description = "The tags to be applied to this resource"
  default = {
    Terraform = "True"
  }
}
