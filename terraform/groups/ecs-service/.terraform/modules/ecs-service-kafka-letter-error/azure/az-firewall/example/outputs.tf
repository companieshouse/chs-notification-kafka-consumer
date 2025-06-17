output "azfirewall" {
  value = module.azfirewall.azfirewall
}

output "azfirewall_public_ip" {
  value = module.azfirewall.azfirewall_public_ip
}

output "azfirewall_policy" {
  value = module.azfirewall.azfirewall_policy
}

output "azfirewall_policy_id" {
  value = module.azfirewall.azfirewall_policy_id
}
