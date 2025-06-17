# encrypted_ami_enablement

Enables the use of encrypted AMIs by AWS service roles by configuring necessary KMS Grants against a provided KMS key.

By default, the AWS-provided `AWSServiceRoleForAutoScaling` service-role will be configured. However any role can be enabled by passing in the appropriate role name.

<!-- BEGIN_TF_DOCS -->
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
| [aws_kms_grant.ebs_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_iam_role.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The name of the AWS account we're operating within | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key to which access will be permitted by the KMS Grants | `string` | n/a | yes |
| <a name="input_service_role_names"></a> [service\_role\_names](#input\_service\_role\_names) | A list of IAM role names that KMS Grants will be configured for | `list(string)` | <pre>[<br>  "AWSServiceRoleForAutoScaling"<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
