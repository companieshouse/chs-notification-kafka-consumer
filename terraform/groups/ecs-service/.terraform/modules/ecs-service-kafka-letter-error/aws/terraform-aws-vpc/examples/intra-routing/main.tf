module "vpc" {
  source = "../../"

  name = var.name

  cidr                    = "10.10.0.0/16"
  azs                     = data.aws_availability_zones.this.names
  map_public_ip_on_launch = false

  intra_subnets   = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
  private_subnets = ["10.10.3.0/24", "10.10.4.0/24", "10.10.5.0/24"]

  enable_nat_gateway = false
  enable_flow_log    = false

  single_intra_route_table = var.single_intra_route_table
}

data "aws_availability_zones" "this" {}