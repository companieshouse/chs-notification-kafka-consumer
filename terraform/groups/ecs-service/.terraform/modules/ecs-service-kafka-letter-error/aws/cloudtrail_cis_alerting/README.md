## About

This module can be used to set up a predefined list of metric filters and alarms for specific events, when CloudTrail has already been configured to log to CloudWatch.
Please see https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cis_sns_kms"></a> [cis\_sns\_kms](#module\_cis\_sns\_kms) | git@github.com:companieshouse/terraform-modules//aws/kms | tags/1.0.235 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_metric_filter.cloudwatch_metric_filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_metric_alarm.cloudwatch_metric_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_sns_topic.cis_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.cis_topic_slack_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [vault_generic_secret.security_alerting](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | Short version of the name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS profile to use | `string` | n/a | yes |
| <a name="input_cis_topic_slack_endpoint"></a> [cis\_topic\_slack\_endpoint](#input\_cis\_topic\_slack\_endpoint) | The slack endpoint (webhook url) to receive notifications for CIS alerts.  If not specified a value from vault will be used. | `string` | `""` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | The name of the CloudWatch Log Group that receives CloudTrail events | `string` | n/a | yes |
| <a name="input_metric_filters"></a> [metric\_filters](#input\_metric\_filters) | A map of metric names => filter patterns that is used to create both a metric filter and an alarm | `map(string)` | See source code for default values | no |
| <a name="input_region"></a> [region](#input\_region) | Short version of the name of the AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to the resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->