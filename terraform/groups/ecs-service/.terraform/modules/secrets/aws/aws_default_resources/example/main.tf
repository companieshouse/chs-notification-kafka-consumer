provider "aws" {
}

module "default_resources" {
  source = "../../aws_default_resources"

  region = var.region
  azs    = var.availability_zones
}