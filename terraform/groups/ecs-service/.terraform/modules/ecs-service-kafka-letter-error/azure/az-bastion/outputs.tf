output "bastion_host" {
  value = azurerm_bastion_host.this
}

output "bastion_public_ip" {
  value = azurerm_public_ip.this
}

output "bastion_network_security_group" {
  value = azurerm_network_security_group.this
}