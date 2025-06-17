# instance_profile

## Overview

A module that will create the required resources for an instance profile

## Usage

```hcl
resource "aws_cloudwatch_log_group" "terratest" {
  name = var.name

  tags = {
    Environment = "test"
    Terratest   = "true"
  }
}

module "instance_policy" {
  source = "../../instance_profile"

  name = var.name
  statement = [
    {
      sid       = "testpolicy"
      effect    = "Allow"
      resources = [aws_cloudwatch_log_group.terratest.arn]
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ]
    }
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.9, < 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 0.3, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 0.3, < 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.ssm_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ssm_kms_key"></a> [ssm\_kms\_key](#input\_ssm\_kms\_key) | If enable\_ssm=true, this will be used to allow the required kms permissions for SSM session encryption | `string` | `null` | no |
| <a name="input_custom_statements"></a> [custom\_statements](#input\_custom\_statements) | The custom statement(s) to use as part of the policy document that is attached to the role, used when the existing statements do not cover the requirement | `any` | `null` | no |
| <a name="input_cw_log_group_arns"></a> [cw\_log\_group\_arns](#input\_cw\_log\_group\_arns) | A list of arns for log groups that an instance should have access to write logs to | `list(string)` | `null` | no |
| <a name="input_enable_ssm"></a> [enable\_ssm](#input\_enable\_ssm) | Enable SSM permissions to allow the instance to access SSM features such as session manager | `bool` | `false` | no |
| <a name="input_instance_asg_arns"></a> [instance\_asg\_arns](#input\_instance\_asg\_arns) | A list of arns for autoscaling groups that an instance can make health updates to | `list(string)` | `null` | no |
| <a name="input_kms_key_refs"></a> [kms\_key\_refs](#input\_kms\_key\_refs) | A list of reference (alias, key\_id) for KMS keys that an instance should have access to make use of | `list(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | A name to use as part of resource naming | `string` | n/a | yes |
| <a name="input_s3_buckets_delete"></a> [s3\_buckets\_delete](#input\_s3\_buckets\_delete) | List of S3 bucket names to grant Delete access to | `list(string)` | `[]` | no |
| <a name="input_s3_buckets_read"></a> [s3\_buckets\_read](#input\_s3\_buckets\_read) | List of S3 bucket names to grant Read access to | `list(string)` | `[]` | no |
| <a name="input_s3_buckets_write"></a> [s3\_buckets\_write](#input\_s3\_buckets\_write) | List of S3 bucket names to grant Write access to | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_iam_instance_profile"></a> [aws\_iam\_instance\_profile](#output\_aws\_iam\_instance\_profile) | Complete output for iam profile, contains all references for this resource |
| <a name="output_aws_iam_policy"></a> [aws\_iam\_policy](#output\_aws\_iam\_policy) | Complete output for iam policy, contains all references for this resource |
| <a name="output_aws_iam_role"></a> [aws\_iam\_role](#output\_aws\_iam\_role) | Complete output for iam role, contains all references for this resource |
| <a name="output_aws_iam_role_policy_attachment"></a> [aws\_iam\_role\_policy\_attachment](#output\_aws\_iam\_role\_policy\_attachment) | Complete output for iam policy attachment, contains all references for this resource |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/#install)
- [golang](https://golang.org/doc/install#install)
- [golint](https://github.com/golang/lint#installation)

### Configurations

- Configure pre-commit hooks
```sh
pre-commit install
```


- Configure golang deps for tests
```sh
> go get github.com/gruntwork-io/terratest/modules/terraform
> go get github.com/stretchr/testify/assert
```



### Tests

- Tests are available in `test` directory

- In the test directory, run the below command
```sh
go test
```



## Authors

This project is authored by below people

- Martin Fox

> This project was generated by [generator-tf-module](https://github.com/sudokar/generator-tf-module)
