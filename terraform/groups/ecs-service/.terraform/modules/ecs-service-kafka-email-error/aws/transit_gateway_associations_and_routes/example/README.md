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
| <a name="module_transit_gateway"></a> [transit\_gateway](#module\_transit\_gateway) | ../../transit_gateway |  |
| <a name="module_transit_gateway_routes"></a> [transit\_gateway\_routes](#module\_transit\_gateway\_routes) | ../../transit_gateway_associations_and_routes |  |

## Resources

| Name | Type |
|------|------|
| [aws_subnet_ids.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_tgw"></a> [create\_tgw](#input\_create\_tgw) | Boolean to create the Transit Gateway, if False will only allow joining of the named Transit Gateway rather thancreate one | `any` | n/a | yes |
| <a name="input_default_route_table_association"></a> [default\_route\_table\_association](#input\_default\_route\_table\_association) | Boolean value, should this VPC be associated with the default route table | `any` | n/a | yes |
| <a name="input_default_route_table_propagation"></a> [default\_route\_table\_propagation](#input\_default\_route\_table\_propagation) | Boolean value, should this VPC propogate its CIDR range to the default route table | `any` | n/a | yes |
| <a name="input_primary_dest_cidr"></a> [primary\_dest\_cidr](#input\_primary\_dest\_cidr) | A cidr address to be applied to a route table | `any` | n/a | yes |
| <a name="input_secondary_dest_cidr"></a> [secondary\_dest\_cidr](#input\_secondary\_dest\_cidr) | A cidr address to be applied to a route table | `any` | n/a | yes |
| <a name="input_share_tgw"></a> [share\_tgw](#input\_share\_tgw) | Boolean to set if this Transit Gateway should be shared via AWS RAM | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_ec2_transit_gateway_route_ids"></a> [this\_ec2\_transit\_gateway\_route\_ids](#output\_this\_ec2\_transit\_gateway\_route\_ids) | List of EC2 Transit Gateway Route Table identifier combined with destination |
| <a name="output_this_ec2_transit_gateway_route_table_associations"></a> [this\_ec2\_transit\_gateway\_route\_table\_associations](#output\_this\_ec2\_transit\_gateway\_route\_table\_associations) | Identifier of the default propagation route table |
| <a name="output_this_ec2_transit_gateway_route_table_propagations"></a> [this\_ec2\_transit\_gateway\_route\_table\_propagations](#output\_this\_ec2\_transit\_gateway\_route\_table\_propagations) | Identifier of the default propagation route table |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
