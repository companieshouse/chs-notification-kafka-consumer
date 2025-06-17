terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "2.3.0"

  resource_group_name = azurerm_resource_group.example.name
  vnet_name           = "${azurerm_resource_group.example.name}-vnet"
  address_space       = ["10.10.0.0/16"]
  subnet_prefixes     = ["10.10.1.0/27"]
  subnet_names        = ["GatewaySubnet"]

  tags = {
    Terratest = "True"
  }

  depends_on = [azurerm_resource_group.example]
}

module "vpn" {
  source = "../../az-vpn-gateway"

  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = module.vnet.vnet_name

  name                     = "${azurerm_resource_group.example.name}-vpn"
  create_gateway           = true
  vpn_public_ip_sku        = "Standard"
  vpn_sku                  = "VpnGw1AZ"
  vpn_enable_active_active = var.enable_active_active

  depends_on = [
    azurerm_resource_group.example,
    module.vnet
  ]
}