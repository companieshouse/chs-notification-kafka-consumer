provider "aws" {
}

// See Notes in README.md for explanation regarding using data-sources and computed values
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.default.id
}


module "transit_gateway" {
  source = "../../transit_gateway"

  name        = "tgw-net-001"
  description = "Transit Gateway to route all traffic between Shared Services, Direct Connect and all other accounts"

  create_tgw                             = true
  share_tgw                              = true
  enable_auto_accept_shared_attachments  = true
  enable_default_route_table_association = false
  enable_default_route_table_propagation = false

  tgw_route_tables = [
    "rt-tgw-primary-001",
    "rt-tgw-secondary-001",
  ]

  ram_name                      = "ram-share-tgw-net-001"
  ram_allow_external_principals = true
  ram_principals                = ["123456789012"]
  tags = {
    Terraform = "true"
  }
}

module "transit_gateway_routes" {
  source = "../../transit_gateway_associations_and_routes"

  tgw_routes_to_create = [
    {
      route_table            = module.transit_gateway.this_ec2_transit_gateway_route_table_ids["rt-tgw-primary-001"]
      destination_cidr_block = var.primary_dest_cidr
      blackhole              = true
    },
    {
      route_table            = module.transit_gateway.this_ec2_transit_gateway_route_table_ids["rt-tgw-secondary-001"]
      destination_cidr_block = var.secondary_dest_cidr
      blackhole              = true
    }
  ]

  tags = {
    Terraform = "true"
  }
}
