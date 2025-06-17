<!-- BEGIN_TF_DOCS -->
# subnet-lookup

A convenience module to retrieve subnet CIDRs

## Example usage

```
# Terraform
module "account_x_lookups" {
  source      = ...

  providers = {
    aws = aws.account_x_provider
  }

  count = length(var.account_x_lookups)

  subnet_pattern = var.account_x_lookups[count.index].subnet_pattern
  vpc_pattern = var.account_x_lookups[count.index].vpc_pattern
}

# Configuration
account_x_lookups = [
  {
    subnet_pattern = "my-subnet-*"
    vpc_pattern = "my-vpc"
  }
]
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0.0, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0.0, < 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_subnet.lookup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.lookup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.lookup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subnet_pattern"></a> [subnet\_pattern](#input\_subnet\_pattern) | The pattern to use when filtering for subnets by name | `string` | n/a | yes |
| <a name="input_vpc_pattern"></a> [vpc\_pattern](#input\_vpc\_pattern) | The pattern to use when filtering for VPCs by name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | The account id relating to the results |
| <a name="output_subnet_cidrs"></a> [subnet\_cidrs](#output\_subnet\_cidrs) | A map of subnet CIDRs keyed by subnet name |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | The name of the matched VPC |
<!-- END_TF_DOCS -->
