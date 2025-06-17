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
  subnet_names        = ["AzureBastionSubnet"]

  tags = {
    Terratest = "True"
  }

  depends_on = [azurerm_resource_group.example]
}

module "bastion" {
  source = "../../az-bastion"

  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  subnet_id           = module.vnet.vnet_subnets[0]

  bastion_name  = "${azurerm_resource_group.example.name}-bastion"
  publicip_name = "${azurerm_resource_group.example.name}-pip-bastion"
  nsg_name      = "${azurerm_resource_group.example.name}-nsg-bastion"
  tags = {
    terratest = "true"
    testname  = var.resource_group_name
  }

  depends_on = [
    azurerm_resource_group.example,
    module.vnet
  ]
}