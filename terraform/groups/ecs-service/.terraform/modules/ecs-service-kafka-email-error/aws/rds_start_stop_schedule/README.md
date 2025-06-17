# rds_start_stop_schedule

Creates resources to permit the scheduled starting and stopping of RDS instances via AWS Systems Manager (SSM) State Manager associations.

An IAM role and associated policies are created to allow the State Manager Associations to interact with the RDS instance.

Associations will execute an SSM Automation document on a schedule defined by the `rds_start_schedule` and `rds_stop_schedule` variables using a simplified expression syntax.

See [Cron and rate expressions for associations](https://docs.aws.amazon.com/systems-manager/latest/userguide/reference-cron-and-rate-expressions.html#reference-cron-and-rate-expressions-association) for more information.

## Usage

```hcl
module "rds_start_stop_schedule" {
  source = "git@github.com:companieshouse/terraform-modules//aws/rds_start_stop_schedule"

  rds_instance_id    = "rds-testinstance-development-001"
  rds_start_schedule = "cron(0 6 * * ? *)"
  rds_stop_schedule  = "cron(0 21 * * ? *)"
}
```

```hcl
module "rds_start_stop_schedule" {
  for_each = var.rds_instances

  source = "git@github.com:companieshouse/terraform-modules//aws/rds_start_stop_schedule"

  rds_instance_id     = "rds-${each.key}-${var.environment}-001"
  rds_schedule_enable = lookup(each.value, "rds_schedule_enable")
  rds_start_schedule  = lookup(each.value, "rds_start_schedule")
  rds_stop_schedule   = lookup(each.value, "rds_stop_schedule")
}
```

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
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_ssm_association.this_start](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_ssm_association.this_stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_db_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_instance) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_rds_instance_id"></a> [rds\_instance\_id](#input\_rds\_instance\_id) | The full Instance Id or Name of the RDS instance | `string` | `""` | no |
| <a name="input_rds_schedule_enable"></a> [rds\_schedule\_enable](#input\_rds\_schedule\_enable) | Defines whether the schedules are active (true) or not (false) | `bool` | `true` | no |
| <a name="input_rds_start_schedule"></a> [rds\_start\_schedule](#input\_rds\_start\_schedule) | The schedule expression string that defines when the RDS instance will be started | `string` | `""` | no |
| <a name="input_rds_stop_schedule"></a> [rds\_stop\_schedule](#input\_rds\_stop\_schedule) | The schedule expression string that defines when the RDS instance will be stopped | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_iam_role_arn"></a> [this\_iam\_role\_arn](#output\_this\_iam\_role\_arn) | ARN for the IAM role |
| <a name="output_this_iam_role_name"></a> [this\_iam\_role\_name](#output\_this\_iam\_role\_name) | Name of the IAM role |
| <a name="output_this_ssm_start_schedule_id"></a> [this\_ssm\_start\_schedule\_id](#output\_this\_ssm\_start\_schedule\_id) | Id of the start schedule's SSM Association |
| <a name="output_this_ssm_stop_schedule_id"></a> [this\_ssm\_stop\_schedule\_id](#output\_this\_ssm\_stop\_schedule\_id) | Id of the stop schedule's SSM Association |
