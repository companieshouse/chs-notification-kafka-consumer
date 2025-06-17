provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "local" {
  source  = "Azure/vnet/azurerm"
  version = "2.3.0"

  resource_group_name = azurerm_resource_group.main.name
  vnet_name           = "${azurerm_resource_group.main.name}-local-vnet"
  address_space       = ["10.10.0.0/16"]
  subnet_prefixes     = ["10.10.1.0/27", "10.10.2.0/24"]
  subnet_names        = ["Subnet1", "Subnet2"]

  tags = {
    Terratest = "True"
  }

  depends_on = [azurerm_resource_group.main]
}

module "remote" {
  source  = "Azure/vnet/azurerm"
  version = "2.3.0"

  resource_group_name = azurerm_resource_group.main.name
  vnet_name           = "${azurerm_resource_group.main.name}-remote-vnet"
  address_space       = ["10.20.0.0/16"]
  subnet_prefixes     = ["10.20.1.0/27", "10.20.2.0/24"]
  subnet_names        = ["Subnet3", "Subnet4"]

  tags = {
    Terratest = "True"
  }

  depends_on = [azurerm_resource_group.main]
}


module "vnet_peer" {
  source = "../../az-vnet-peering"

  local_resource_group_name   = azurerm_resource_group.main.name
  local_virtual_network_name  = module.local.vnet_name
  remote_resource_group_name  = azurerm_resource_group.main.name
  remote_virtual_network_name = module.remote.vnet_name
  vnet_peer_config            = local.vnet_peer

  tags = merge(
    local.default_tags,
    map("peer", local.vnet_peer.peer_name)
  )

  depends_on = [azurerm_resource_group.main]
}
