output "inbound_rules" {
  value = [for rule in azurerm_network_security_rule.inbound_rules : rule]
}

output "outbound_rules" {
  value = [for rule in azurerm_network_security_rule.outbound_rules : rule]
}
