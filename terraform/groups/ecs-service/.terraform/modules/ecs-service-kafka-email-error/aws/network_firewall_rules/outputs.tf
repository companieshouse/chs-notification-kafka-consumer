output "aws_networkfirewall_csv_stateless_rule_groups" {
  value = { for rule_group in aws_networkfirewall_rule_group.csv_stateless_rule_groups : rule_group.tags.priority => rule_group.arn } 
}

output "aws_networkfirewall_csv_domain_rule_groups" {
  value =    { for rule_group in aws_networkfirewall_rule_group.csv_domain_rule_groups : rule_group.tags.priority => rule_group.arn } 
}
