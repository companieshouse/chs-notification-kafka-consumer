output "network_acl" {
  description = "The Default Network ACL"
  value       = module.default_resources.network_acl
}

output "route_table" {
  description = "The Default Route Table"
  value       = module.default_resources.route_table
}

output "security_group" {
  description = "The Default Security Group"
  value       = module.default_resources.security_group
}

output "subnets" {
  description = "The Default Subnets"
  value       = module.default_resources.subnets
}

output "vpc" {
  description = "The Default VPC"
  value       = module.default_resources.vpc
}

output "vpc_dhcp_options" {
  description = "The Default VPC DHCP Options Set"
  value       = module.default_resources.vpc_dhcp_options
}