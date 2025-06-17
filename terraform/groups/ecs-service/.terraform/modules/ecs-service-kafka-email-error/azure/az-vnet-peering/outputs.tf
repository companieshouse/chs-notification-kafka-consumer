output "vnet_peering_local" {
  value = azurerm_virtual_network_peering.local
}

output "vnet_peering_remote" {
  value = azurerm_virtual_network_peering.remote
}