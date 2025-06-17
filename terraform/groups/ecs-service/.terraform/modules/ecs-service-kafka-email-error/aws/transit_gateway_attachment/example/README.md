# Complete AWS Transit Gateway example

Configuration in this directory creates AWS Transit Gateway, attach VPC to it and share it with other AWS principals using [Resource Access Manager (RAM)](https://aws.amazon.com/ram/).

## Notes

There is a famous limitation in Terraform which prevents us from using computed values in `count`. For this reason this example is using data-sources to discover already created default VPC and subnets.

In real-world scenario you will have to split creation of VPC (using [terraform-aws-vpc modules](https://github.com/terraform-aws-modules/terraform-aws-vpc)) and creation of TGW resources using this module. 

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tgw_attachment"></a> [tgw\_attachment](#module\_tgw\_attachment) | ../../transit_gateway_attachment |  |
| <a name="module_transit_gateway"></a> [transit\_gateway](#module\_transit\_gateway) | ../../transit_gateway |  |

## Resources

| Name | Type |
|------|------|
| [aws_subnet_ids.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_tgw"></a> [create\_tgw](#input\_create\_tgw) | Boolean to set if this Transit Gateway should be created | `any` | n/a | yes |
| <a name="input_default_route_table_association"></a> [default\_route\_table\_association](#input\_default\_route\_table\_association) | Boolean value, should this VPC be associated with the default route table | `any` | n/a | yes |
| <a name="input_default_route_table_propagation"></a> [default\_route\_table\_propagation](#input\_default\_route\_table\_propagation) | Boolean value, should this VPC propogate its CIDR range to the default route table | `any` | n/a | yes |
| <a name="input_dns_support"></a> [dns\_support](#input\_dns\_support) | Enable DNS support on TGW Attachment | `any` | n/a | yes |
| <a name="input_ipv6_support"></a> [ipv6\_support](#input\_ipv6\_support) | Enable IPV6 support on TGW Attachment | `any` | n/a | yes |
| <a name="input_appliance_mode_support"></a> [appliance\_mode\_support](#input\_appliance\_mode\_support) | Enable appliance mode on TGW Attachment | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name to use for Transit Gateway work | `any` | n/a | yes |
| <a name="input_share_tgw"></a> [share\_tgw](#input\_share\_tgw) | Boolean to set if this Transit Gateway should be shared via AWS RAM | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_ec2_transit_gateway_vpc_attachment"></a> [this\_ec2\_transit\_gateway\_vpc\_attachment](#output\_this\_ec2\_transit\_gateway\_vpc\_attachment) | Map of EC2 Transit Gateway VPC Attachment attributes |
| <a name="output_this_ec2_transit_gateway_vpc_attachment_ids"></a> [this\_ec2\_transit\_gateway\_vpc\_attachment\_ids](#output\_this\_ec2\_transit\_gateway\_vpc\_attachment\_ids) | List of EC2 Transit Gateway VPC Attachment identifiers |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
