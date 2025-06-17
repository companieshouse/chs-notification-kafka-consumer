variable "resource_group_name" {
  type        = string
  description = "The resource group name this virtual network will be created in"
}

variable "subnet_id" {
  type        = string
  description = "The subnet ID resources are to be created in"
}

variable "location" {
  type        = string
  description = "The location resources will be located in once deployed"
}

variable "azfirewall_name" {
  type        = string
  description = "The name for the instance of Azure Firewall"
  default     = "azfirewall-001"
}

variable "dns_servers" {
  type        = list(string)
  description = "A list of DNS servers to use in the Firewall Policy DNS section"
  default     = null
}

variable "dns_proxy_enabled" {
  type        = bool
  description = "Boolean, enable Azure Firewall as a DNS Proxy using provided DNS Servers"
  default     = false
}

variable "ip_configuration_name_prefix" {
  type        = string
  description = "The IP configuration name initially assigned to the deployed Azure Firewall"
  default     = "azfw-ipconf"
}

variable "publicip_name_prefix" {
  type        = string
  description = "The name for the Public IP for Azure Firewall"
  default     = "pip-azfirewall"
}

variable "additional_public_ips" {
  type        = number
  description = "The total number of additional Public IPs to create for the firewall"
  default     = 0
}

variable "sku" {
  type        = string
  description = "The SKU for both the Azure Firewall and the Firewall Policy. Options are Standard or Premium"
  default     = "Standard"
}

variable "sku_type" {
  type        = string
  description = "The SKU type for the Azure Firewall. Options are AZFW_Hub or AZFW_VNet"
  default     = "AZFW_VNet"
}

variable "threat_intelligence_mode" {
  type        = string
  description = "The opertion mode for threat intelligence"
  default     = "Alert"
}

variable "azfirewall_policy_name" {
  type        = string
  description = "The name for the Azure Firewall Policy"
  default     = "azfw-policy-001"
}

variable "tags" {
  type        = map
  description = "The tags to be applied to this resource"
  default = {
    terraform = "true"
  }
}