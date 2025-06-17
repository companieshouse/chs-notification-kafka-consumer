data "azurerm_resource_group" "local" {
  name = var.local_resource_group_name
}

data "azurerm_virtual_network" "local" {
  name                = var.local_virtual_network_name
  resource_group_name = var.local_resource_group_name
}

data "azurerm_resource_group" "remote" {
  name = var.remote_resource_group_name
}

data "azurerm_virtual_network" "remote" {
  name                = var.remote_virtual_network_name
  resource_group_name = var.remote_resource_group_name
}

resource "azurerm_virtual_network_peering" "local" {
  name                         = "${var.vnet_peer_config.peer_name}-local"
  resource_group_name          = data.azurerm_resource_group.local.name
  virtual_network_name         = data.azurerm_virtual_network.local.name
  remote_virtual_network_id    = data.azurerm_virtual_network.remote.id
  allow_virtual_network_access = var.vnet_peer_config.local.allow_virtual_network_access
  allow_forwarded_traffic      = var.vnet_peer_config.local.allow_forwarded_traffic
  allow_gateway_transit        = var.vnet_peer_config.local.allow_gateway_transit
  use_remote_gateways          = var.vnet_peer_config.local.use_remote_gateways
}

resource "azurerm_virtual_network_peering" "remote" {
  name                         = "${var.vnet_peer_config.peer_name}-remote"
  resource_group_name          = data.azurerm_resource_group.remote.name
  virtual_network_name         = data.azurerm_virtual_network.remote.name
  remote_virtual_network_id    = data.azurerm_virtual_network.local.id
  allow_virtual_network_access = var.vnet_peer_config.remote.allow_virtual_network_access
  allow_forwarded_traffic      = var.vnet_peer_config.remote.allow_forwarded_traffic
  allow_gateway_transit        = var.vnet_peer_config.remote.allow_gateway_transit
  use_remote_gateways          = var.vnet_peer_config.remote.use_remote_gateways
}
