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
  subnet_prefixes     = ["10.10.1.0/26"]
  subnet_names        = ["AzureFirewallSubnet"]

  tags = {
    Terratest = "True"
  }

  depends_on = [azurerm_resource_group.example]
}

module "azfirewall" {
  source = "../../az-firewall"

  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  subnet_id           = module.vnet.vnet_subnets[0]

  dns_servers       = ["8.8.8.8", "8.8.4.4"]
  dns_proxy_enabled = true

  azfirewall_name       = "${azurerm_resource_group.example.name}-azfirewall"
  publicip_name_prefix  = "${azurerm_resource_group.example.name}-pip-azfirewall"
  additional_public_ips = 3

  tags = {
    terratest = "true"
    testname  = var.resource_group_name
  }

  depends_on = [
    azurerm_resource_group.example,
    module.vnet
  ]
}