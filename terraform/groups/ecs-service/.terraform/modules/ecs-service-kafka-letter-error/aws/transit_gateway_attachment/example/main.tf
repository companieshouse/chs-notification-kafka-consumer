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

  create_tgw                             = var.create_tgw
  share_tgw                              = var.share_tgw
  enable_auto_accept_shared_attachments  = true
  enable_default_route_table_association = var.default_route_table_association
  enable_default_route_table_propagation = var.default_route_table_propagation

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


module "tgw_attachment" {
  source = "../../transit_gateway_attachment"

  name = var.name

  vpc_attachments = {
    dev = {
      tgw_id                                          = module.transit_gateway.this_ec2_transit_gateway_id
      vpc_id                                          = data.aws_vpc.default.id
      subnet_ids                                      = data.aws_subnet_ids.this.ids
      dns_support                                     = var.dns_support
      ipv6_support                                    = var.ipv6_support
      appliance_mode_support                          = var.appliance_mode_support
      transit_gateway_default_route_table_association = var.default_route_table_association
      transit_gateway_default_route_table_propagation = var.default_route_table_propagation

      tgw_vpc_attachment_tags = {
        vpc_id = data.aws_vpc.default.id
      }
    },
  }

  tags = {
    Terraform = "true"
  }
}