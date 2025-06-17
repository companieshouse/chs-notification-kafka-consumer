
# Terraform AWS CloudTrail

This module will allow CloudTrail trails to be created and Cloudwatch, S3 or both to be set as the destination for the logs. Encryption can be enabled for the logs via KMS and a new KMS key will be created by this module.

S3 is constant, and all logs must go to S3, CloudWatch can be enabled/disabled as seen fit but S3 must always be used. The module will not create the S3 bucket so and S3 bucket Id must be supplied to the module.

## Usage

Basic example of S3 logging

```hcl
module "aws_cloudtrail" {
    source = "git@github.com:companieshouse/terraform-modules//aws/cloudtrail"
    s3_bucket_name     = "my-company-cloudtrail-logs"
}
```

Complete example using CloudWatch, S3 and KMS Key encryption. 
Log retention is for CloudWatch only, S3 bucket policy will control logs stored in S3.

```hcl
module "aws_cloudtrail" {
    source = "git@github.com:companieshouse/terraform-modules//aws/cloudtrail"
    
    enabled    = true
    trail_name = "my-company_cloudtrail"
    org_trail  = false

    s3_bucket_name = "my-company-cloudtrail-logs"
    
    setup_encryption            = true
    key_deletion_window_in_days = 20

    cloudwatch_logging = true
    log_retention_days = 90


}
```

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
| [aws_cloudtrail.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.cloudtrail_cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.cloudtrail_cloudwatch_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.cloudtrail_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudtrail_cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | The name of the CloudWatch Log Group that receives CloudTrail events. | `string` | `"cloudtrail-events"` | no |
| <a name="input_cloudwatch_logging"></a> [cloudwatch\_logging](#input\_cloudwatch\_logging) | Enable or Disable CloudWatch Logging for CloudTrail | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enables logging for the trail. Defaults to true. Setting this to false will pause logging. | `bool` | `true` | no |
| <a name="input_encrypt_trail"></a> [encrypt\_trail](#input\_encrypt\_trail) | True to enable KMS encryption on Cloudtrail using the KMS key provided in var.kms\_key | `bool` | `true` | no |
| <a name="input_event_selector"></a> [event\_selector](#input\_event\_selector) | Specifies an event selector for enabling data event logging. | <pre>list(object({<br>    include_management_events = bool<br>    read_write_type           = string<br><br>    data_resource = list(object({<br>      type   = string<br>      values = list(string)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_key_deletion_window_in_days"></a> [key\_deletion\_window\_in\_days](#input\_key\_deletion\_window\_in\_days) | Duration in days after which the key is deleted after destruction of the resource, must be 7-30 days.  Default 30 days. | `string` | `30` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | Provide a KMS key identifier to setup encryption for CloudTrail logs. | `string` | `null` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Number of days to keep AWS logs around in specific log group. | `string` | `90` | no |
| <a name="input_org_trail"></a> [org\_trail](#input\_org\_trail) | Whether or not this is an organization trail. Only valid in master account. | `string` | `"false"` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of the AWS S3 bucket. | `string` | n/a | yes |
| <a name="input_s3_key_prefix"></a> [s3\_key\_prefix](#input\_s3\_key\_prefix) | S3 key prefix for CloudTrail logs | `string` | `"cloudtrail"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to the resources created in this module | `map(any)` | <pre>{<br>  "Terraform": "True"<br>}</pre> | no |
| <a name="input_trail_name"></a> [trail\_name](#input\_trail\_name) | Name for the Cloudtrail | `string` | `"cloudtrail"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudtrail_arn"></a> [cloudtrail\_arn](#output\_cloudtrail\_arn) | CloudTrail ARN |
| <a name="output_cloudtrail_home_region"></a> [cloudtrail\_home\_region](#output\_cloudtrail\_home\_region) | CloudTrail Home Region |
| <a name="output_cloudtrail_id"></a> [cloudtrail\_id](#output\_cloudtrail\_id) | CloudTrail ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Developer Setup

Install dependencies (macOS)

```shell
brew install pre-commit go terraform terraform-docs
```

### Testing

[Terratest](https://github.com/gruntwork-io/terratest) is being used for
automated testing with this module. Tests in the `test` folder can be run
locally by running the following command:

```text
make test
```

Or with aws-vault:

```text
AWS_VAULT_KEYCHAIN_NAME=<NAME> aws-vault exec <PROFILE> -- make test
```
