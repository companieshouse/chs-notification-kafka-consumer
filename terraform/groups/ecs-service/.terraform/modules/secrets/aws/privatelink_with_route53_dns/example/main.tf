data "aws_availability_zones" "available_zones" {
  state = "available"
}

data "aws_availability_zone" "zone_details" {
  for_each = toset(data.aws_availability_zones.available_zones.names)
  name     = each.value
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.57.0"

  name = var.name

  cidr = "10.11.0.0/16"

  azs             = data.aws_availability_zones.available_zones.names
  private_subnets = [for az in data.aws_availability_zones.available_zones.names : cidrsubnet("10.11.0.0/16", 8, var.az_number[data.aws_availability_zone.zone_details[az].name_suffix])]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_ipv6 = false

  tags = {
    Owner       = var.name
    Environment = "test"
  }

  vpc_tags = {
    Name = var.name
  }
}

data "aws_security_groups" "default" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}

module "privatelink" {
  source = "../../privatelink_with_route53_dns"

  service_name        = var.service_name
  private_dns_enabled = false
  vpc_id              = module.vpc.vpc_id
  security_group_ids  = data.aws_security_groups.default.ids
  subnet_ids          = module.vpc.private_subnets

  tags = {
    test = true
  }

}
