provider "aws" {
}

module "public_zones" {
  source = "../../route53_zones"

  zones = var.public_zones
}

module "private_zones" {
  source = "../../route53_zones"

  zones              = var.private_zones
  ignore_vpc_changes = true
}