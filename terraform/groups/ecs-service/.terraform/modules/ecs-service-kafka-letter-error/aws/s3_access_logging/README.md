<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket_logging.access_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The account name, used in s3 logging bucket name.  E.g. development, staging or live. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The account region, used in s3 logging bucket name.  E.g. eu-west-2. | `string` | n/a | yes |
| <a name="input_source_s3_bucket_name"></a> [source\_s3\_bucket\_name](#input\_source\_s3\_bucket\_name) | The source s3 bucket name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
