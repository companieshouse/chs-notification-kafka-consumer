<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0, < 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.8, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.8, < 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.firewall_alerts_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_networkfirewall_firewall.firewall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall) | resource |
| [aws_networkfirewall_firewall_policy.firewall_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy) | resource |
| [aws_networkfirewall_logging_configuration.firewall_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_logging_configuration) | resource |
| [aws_kms_key.cloudwatch_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_kms_key"></a> [cloudwatch\_kms\_key](#input\_cloudwatch\_kms\_key) | KMS key to use for encryption of Firewall Cloudwatch logs (if enabled). Null to disable log encryption. | `string` | `null` | no |
| <a name="input_cloudwatch_log_retention_days"></a> [cloudwatch\_log\_retention\_days](#input\_cloudwatch\_log\_retention\_days) | Number of days to retain cloudwatch firewall logs for (if enabled). | `number` | `180` | no |
| <a name="input_domain_rule_groups"></a> [domain\_rule\_groups](#input\_domain\_rule\_groups) | List of domain rule group ARNs to attach to the firewall policy. | `map(string)` | `{}` | no |
| <a name="input_enable_firewall_cloudwatch_alert_logs"></a> [enable\_firewall\_cloudwatch\_alert\_logs](#input\_enable\_firewall\_cloudwatch\_alert\_logs) | True to enable logging of firewall alert logs to a log group created by this module. | `bool` | `false` | no |
| <a name="input_enable_firewall_cloudwatch_flow_logs"></a> [enable\_firewall\_cloudwatch\_flow\_logs](#input\_enable\_firewall\_cloudwatch\_flow\_logs) | True to enable logging of firewall flow logs to a log group created by this module. | `bool` | `false` | no |
| <a name="input_filewall_stateful_engine_evaluation_order"></a> [filewall\_stateful\_engine\_evaluation\_order](#input\_filewall\_stateful\_engine\_evaluation\_order) | Evaluation order for the stateful rule engine of the firewall policy. Valid options: DEFAULT\_ACTION\_ORDER, STRICT\_ORDER. Default DEFAULT\_ACTION\_ORDER | `string` | `"DEFAULT_ACTION_ORDER"` | no |
| <a name="input_firewall_alert_logs_bucket_name"></a> [firewall\_alert\_logs\_bucket\_name](#input\_firewall\_alert\_logs\_bucket\_name) | Name of the S3 bucket to store firewall alert logs in. The bucket policy must be updated to provide access to the 'delivery.logs.amazonaws.com' principle from the firewall account. Set value as null to disable firewall alert logging to S3. | `string` | `null` | no |
| <a name="input_firewall_delete_protection"></a> [firewall\_delete\_protection](#input\_firewall\_delete\_protection) | A boolean flag indicating whether deletion protection is enabled. | `bool` | `false` | no |
| <a name="input_firewall_endpoint_subnets"></a> [firewall\_endpoint\_subnets](#input\_firewall\_endpoint\_subnets) | List of Subnet ID's to deploy firewall endpoints into. | `list(string)` | n/a | yes |
| <a name="input_firewall_flow_logs_bucket_name"></a> [firewall\_flow\_logs\_bucket\_name](#input\_firewall\_flow\_logs\_bucket\_name) | Name of the S3 bucket to store firewall flow logs in. The bucket policy must be updated to provide access to the 'delivery.logs.amazonaws.com' principle from the firewall account. Set value as null to disable firewall flow logging to S3. | `string` | `null` | no |
| <a name="input_firewall_policy_change_protection"></a> [firewall\_policy\_change\_protection](#input\_firewall\_policy\_change\_protection) | A boolean flag indicating whether it is possible to change the associated firewall policy. | `bool` | `false` | no |
| <a name="input_managed_rule_group_arns"></a> [managed\_rule\_group\_arns](#input\_managed\_rule\_group\_arns) | List of managed rule group ARNs to attach to the firewall policy. | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Unique name to identify all resources in this deployment. | `string` | n/a | yes |
| <a name="input_s3_access_logs_prefix"></a> [s3\_access\_logs\_prefix](#input\_s3\_access\_logs\_prefix) | Key prefix for any Firewall logs configured to be stored in S3 | `string` | `""` | no |
| <a name="input_stateful_default_actions"></a> [stateful\_default\_actions](#input\_stateful\_default\_actions) | Set of actions to take on a packet if it does not match any stateful rules in the policy. This can only be specified if the policy has a stateful\_engine\_options block with a rule\_order value of STRICT\_ORDER. You can specify one of either or neither values of aws:drop\_strict or aws:drop\_established, as well as any combination of aws:alert\_strict and aws:alert\_established. | `set(string)` | <pre>[<br>  "aws:alert_strict",<br>  "aws:alert_established"<br>]</pre> | no |
| <a name="input_stateful_rule_groups"></a> [stateful\_rule\_groups](#input\_stateful\_rule\_groups) | Map of stateless rule groups and their priority to be attached to the Network firewall policy in the format { "1": "rule\_group" }, were the key is a unique rule group priority in the policy, and the value is the arn of the stateless rule group. | `map(string)` | `{}` | no |
| <a name="input_stateless_default_actions"></a> [stateless\_default\_actions](#input\_stateless\_default\_actions) | Set of actions to take on a packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: aws:drop, aws:pass, or aws:forward\_to\_sfe. | `string` | `"aws:forward_to_sfe"` | no |
| <a name="input_stateless_fragment_default_actions"></a> [stateless\_fragment\_default\_actions](#input\_stateless\_fragment\_default\_actions) | Set of actions to take on a fragmented packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: aws:drop, aws:pass, or aws:forward\_to\_sfe. | `string` | `"aws:forward_to_sfe"` | no |
| <a name="input_stateless_rule_groups"></a> [stateless\_rule\_groups](#input\_stateless\_rule\_groups) | Map of stateless rule groups and their priority to be attached to the Network firewall policy in the format { "1": "rule\_group" }, were the key is a unique rule group priority in the policy, and the value is the arn of the stateless rule group. | `map(string)` | `{}` | no |
| <a name="input_subnet_change_protection"></a> [subnet\_change\_protection](#input\_subnet\_change\_protection) | A boolean flag indicating whether it is possible to change the associated subnet(s). | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to all taggable resources deployed by this module. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id of the VPC to deploy the firewall device in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_network_firewall_arn"></a> [aws\_network\_firewall\_arn](#output\_aws\_network\_firewall\_arn) | n/a |
| <a name="output_aws_network_firewall_id"></a> [aws\_network\_firewall\_id](#output\_aws\_network\_firewall\_id) | n/a |
| <a name="output_aws_network_firewall_status"></a> [aws\_network\_firewall\_status](#output\_aws\_network\_firewall\_status) | n/a |
| <a name="output_aws_network_firewall_update_token"></a> [aws\_network\_firewall\_update\_token](#output\_aws\_network\_firewall\_update\_token) | n/a |
<!-- END_TF_DOCS -->