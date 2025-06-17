output "public_ip" {
  value = azurerm_public_ip.this
}

output "public_ip_active_active" {
  value = var.vpn_enable_active_active == true ? azurerm_public_ip.this_active_active : null
}

output "vpn_gateway" {
  value = azurerm_virtual_network_gateway.this
}