output "account_id" {
  description = "The account id relating to the results"
  value       = data.aws_caller_identity.current.account_id
}

output "subnet_cidrs" {
  description = "A map of subnet CIDRs keyed by subnet name"
  value       = local.subnet_cidrs
}

output "vpc_name" {
  description = "The name of the matched VPC"
  value       = data.aws_vpc.lookup.tags["Name"]
}
