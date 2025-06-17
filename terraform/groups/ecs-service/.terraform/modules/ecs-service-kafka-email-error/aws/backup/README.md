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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_infrastructure_tags"></a> [infrastructure\_tags](#module\_infrastructure\_tags) | git@github.com:companieshouse/terraform-modules//aws/infrastructure-tags | tags/1.0.295 |

## Resources

| Name | Type |
|------|------|
| [aws_backup_plan.backup_plans](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_selection.backup_selections](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.backup_vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_iam_role.backup_selection_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_policy_document.backup_service_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_backup_retentions_days"></a> [backup\_retentions\_days](#input\_backup\_retentions\_days) | A set of retention periods in days | `set(string)` | n/a | yes |
| <a name="input_completion_window_minutes"></a> [completion\_window\_minutes](#input\_completion\_window\_minutes) | The amount of time in minutes AWS Backup attempts a backup before canceling the job and returning an error | `number` | n/a | yes |
| <a name="input_cron_schedule_expression"></a> [cron\_schedule\_expression](#input\_cron\_schedule\_expression) | Backup cron scheduler expression | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_repository"></a> [repository](#input\_repository) | The provisioning repository | `string` | n/a | yes |
| <a name="input_start_window_minutes"></a> [start\_window\_minutes](#input\_start\_window\_minutes) | The amount of time in minutes before beginning a backup | `number` | n/a | yes |
| <a name="input_team"></a> [team](#input\_team) | The owning team | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tags"></a> [tags](#output\_tags) | n/a |
<!-- END_TF_DOCS -->