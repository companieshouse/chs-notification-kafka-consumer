# AWS Transit Gateway Terraform module

Terraform module which creates Transit Gateway resources on AWS.

This type of resources are supported:

* [Transit Gateway Route](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_route.html)
* [Transit Gateway VPC Attachment](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_vpc_attachment.html)

Not supported yet:

* [Transit Gateway VPC Attachment Accepter](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_vpc_attachment_accepter.html)

## Terraform versions

Only Terraform 0.12 or newer is supported.

## Usage with VPC module

Note the VPC should exist **BEFORE** the Transit Gateway due to Terraform and race conditions.

```hcl
provider "aws" {
}

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
  ram_principals = ["123456789012"]
  tags = {
    Terraform   = "true"
  }
}

module "tgw_attachment" {
  source  = "./modules/transit_gateway_attachment"

  name            = "tgw-attach-001"

  vpc_attachments = {
    default-vpc = {
      tgw_id                                          = module.transit_gateway.this_ec2_transit_gateway_id
      vpc_id                                          = data.aws_vpc.default.id
      subnet_ids                                      = data.aws_subnet_ids.sser.ids
      dns_support                                     = true
      ipv6_support                                    = false
      appliance_mode_support                          = false
      
      tgw_vpc_attachment_tags = {
        vpc_id   = module.sser.vpc_id
      }
    },
}
  
  tags = {
    Terraform   = "true"
  }

}
```

## Useful to know

Routes added in each VPC Attachment under *tgw_routes* are added to the non-default route table that is created. To add a VPC CIDR address to the default route table for the Transit Gateway you must set *transit_gateway_default_route_table_propagation* to **true**.

Example scenarios for Transit Gateway architecture can be found in the AWS Documentation: https://docs.aws.amazon.com/vpc/latest/tgw/TGW_Scenarios.html


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3, < 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_attachments"></a> [vpc\_attachments](#input\_vpc\_attachments) | Maps of maps of VPC details to attach to TGW. Type 'any' to disable type validation by Terraform. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_ec2_transit_gateway_vpc_attachment"></a> [this\_ec2\_transit\_gateway\_vpc\_attachment](#output\_this\_ec2\_transit\_gateway\_vpc\_attachment) | Map of EC2 Transit Gateway VPC Attachment attributes |
| <a name="output_this_ec2_transit_gateway_vpc_attachment_ids"></a> [this\_ec2\_transit\_gateway\_vpc\_attachment\_ids](#output\_this\_ec2\_transit\_gateway\_vpc\_attachment\_ids) | List of EC2 Transit Gateway VPC Attachment identifiers |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko).

## License

Apache 2 Licensed. See LICENSE for full details.
