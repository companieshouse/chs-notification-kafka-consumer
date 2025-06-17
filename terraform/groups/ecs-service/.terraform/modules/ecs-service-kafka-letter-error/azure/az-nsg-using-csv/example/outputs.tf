output "inbound_rules" {
  value = module.nsg_rules.inbound_rules
}

output "outbound_rules" {
  value = module.nsg_rules.outbound_rules
}
