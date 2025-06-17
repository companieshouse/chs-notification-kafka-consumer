output "aws_networkfirewall_csv_stateless_rule_groups" {
  value = module.firewall_rules.aws_networkfirewall_csv_stateless_rule_groups
}

output "aws_networkfirewall_csv_domain_rule_groups" {
  value = module.firewall_rules.aws_networkfirewall_csv_domain_rule_groups
}
