# AWS Transit Gateway Terraform module

Terraform module which creates Transit Gateway resources on AWS.

This type of resources are supported:

* [Transit Gateway Route](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_route.html)
* [Transit Gateway Route Table Association](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_route_table_association.html)
* [Transit Gateway Route Table Propagation](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_route_table_propagation.html)

## Terraform versions

Only Terraform 0.12 or newer is supported.

## Usage with VPC module

Note the Transit Gateway and Transit Gateway Attachment should exist **BEFORE** the Transit Gateway routes can be applied.

```hcl
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
  source  = "../../transit_gateway"
  
  name        = "tgw-net-001"
  description = "Transit Gateway to route all traffic between Shared Services, Direct Connect and all other accounts"
  
  create_tgw      = true
  share_tgw       = true
  enable_auto_accept_shared_attachments = true
  enable_default_route_table_association = false
  enable_default_route_table_propagation = false
  
  tgw_route_tables = [
    "rt-tgw-primary-001", 
    "rt-tgw-secondary-001", 
    ]

  ram_name                      = "ram-share-tgw-net-001"
  ram_allow_external_principals = true
  ram_principals = ["123456789012"]
  tags = {
    Terraform   = "true"
  }
}

module "tgw_attachment" {
  source  = "../../transit_gateway_attachment"

  name            = var.name

  # ram_resource_share_arn         = "arn:aws:ram:eu-west-2:903815704705:resource-share/35dd01f6-e81f-4707-afdb-8ab8ff3175fd"

  vpc_attachments = {
    dev = {
      tgw_id                                          = module.transit_gateway.this_ec2_transit_gateway_id
      vpc_id                                          = data.aws_vpc.default.id
      subnet_ids                                      = data.aws_subnet_ids.this.ids
      dns_support                                     = var.dns_support
      ipv6_support                                    = var.ipv6_support
      transit_gateway_default_route_table_association = var.default_route_table_association
      transit_gateway_default_route_table_propagation = var.default_route_table_propagation
      
      tgw_vpc_attachment_tags = {
        vpc_id   = data.aws_vpc.default.id
      }
    },
  }
  
  tags = {
    Terraform   = "true"
  }
}

module "transit_gateway_routes" {
  source  = "../../transit_gateway_associations_and_routes"
  
  // Transit Gateway Route Table association for Transit Gateway attachments, can propagate the CIDR for the VPC to the associated route if required (true/false)
  tgw_route_table_association = [
    {
    tgw_attachment_id    = module.tgw_attachment.this_ec2_transit_gateway_vpc_attachment_ids[0]
    route_table          = module.transit_gateway.this_ec2_transit_gateway_route_table_ids["rt-tgw-primary-001"]
    propagate_vpc_cidr   = true
    }
  ]

  // Route propagation for Transit Gateway attachments, allows propagation to non-associated Transit Gateway Route Table.
  tgw_route_table_propagate = [
    {
    tgw_attachment_id = module.tgw_attachment.this_ec2_transit_gateway_vpc_attachment_ids[0]
    route_table       = module.transit_gateway.this_ec2_transit_gateway_route_table_ids["rt-tgw-secondary-001"]
    }
  ]

  // Static routes to be applied to a Transit Gateway Route Table
  tgw_routes_to_create = [
    {
      route_table = module.transit_gateway.this_ec2_transit_gateway_route_table_ids["rt-tgw-secondary-001"]
      destination_cidr_block = "0.0.0.0/0"
      tgw_attachment_id = module.tgw_attachment.this_ec2_transit_gateway_vpc_attachment_ids[0]
    }
  ]

  tags = {
    Terraform   = "true"
  }
}

```

## Useful to know

This modile has the ability to create static routes, route table associations and route table propagations.
Each of these are mutually exclusive and the module can be used for any one of them individually.

The module is designed to be used with existing Transit Gateways and Transit Gateway Attachments as the Transit Gateway Attachments IDs are required for non BlackHole routes.

Example scenarios for Transit Gateway architecture can be found in the AWS Documentation: https://docs.aws.amazon.com/vpc/latest/tgw/TGW_Scenarios.html


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.9, < 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0, < 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.this_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.this_propagate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tgw_route_table_association"></a> [tgw\_route\_table\_association](#input\_tgw\_route\_table\_association) | Map of route table associations for tgw attachments | `list(any)` | `[]` | no |
| <a name="input_tgw_route_table_propagate"></a> [tgw\_route\_table\_propagate](#input\_tgw\_route\_table\_propagate) | Map of routes to propagate for tgw attachments | `list(any)` | `[]` | no |
| <a name="input_tgw_routes_to_create"></a> [tgw\_routes\_to\_create](#input\_tgw\_routes\_to\_create) | Map of routes to create and the designated route table to use | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_ec2_transit_gateway_route_ids"></a> [this\_ec2\_transit\_gateway\_route\_ids](#output\_this\_ec2\_transit\_gateway\_route\_ids) | List of EC2 Transit Gateway Route Table identifier combined with destination |
| <a name="output_this_ec2_transit_gateway_route_table_associations"></a> [this\_ec2\_transit\_gateway\_route\_table\_associations](#output\_this\_ec2\_transit\_gateway\_route\_table\_associations) | Identifier of the default propagation route table |
| <a name="output_this_ec2_transit_gateway_route_table_attach_propagations"></a> [this\_ec2\_transit\_gateway\_route\_table\_attach\_propagations](#output\_this\_ec2\_transit\_gateway\_route\_table\_attach\_propagations) | Identifier of the default propagation route table |
| <a name="output_this_ec2_transit_gateway_route_table_propagate_propagations"></a> [this\_ec2\_transit\_gateway\_route\_table\_propagate\_propagations](#output\_this\_ec2\_transit\_gateway\_route\_table\_propagate\_propagations) | Identifier of the default propagation route table |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko).

## License

Apache 2 Licensed. See LICENSE for full details.
