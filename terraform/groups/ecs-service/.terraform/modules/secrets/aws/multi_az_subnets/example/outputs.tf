output "vpc" {
  value = aws_vpc.main
}

output "networks" {
  value = module.subnets.networks
}

output "subnet_ids" {
  value = module.subnets.subnet_ids
}

output "named_subnet_ids" {
  value = module.subnets.named_subnet_ids
}

