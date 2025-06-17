output "azfirewall" {
  value = azurerm_firewall.this
}

output "azfirewall_public_ip" {
  value = azurerm_public_ip.this
}

output "azfirewall_policy" {
  value = azurerm_firewall_policy.this
}

output "azfirewall_policy_id" {
  value = azurerm_firewall_policy.this.id
}