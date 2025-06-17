# asg-cloudwatch-alarms

## Overview

This module will create Alarms for the Autoscaling Group specified.
The alarms are configurable with different inputs and will trigger based on those inputs

This module does not provide autoscaling capabilities but can be used to aid that work via the outputs.

## Usage

```hcl

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  # Autoscaling group
  name = "${var.name}-asg"

  vpc_zone_identifier = data.aws_subnet_ids.this.ids
  min_size            = 0
  max_size            = 1
  desired_capacity    = 1

  image_id          = data.aws_ami.amazon_linux.id
  health_check_type = "EC2"
  instance_type     = "t3.micro"

}

module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 2.0"

  name         = "${var.name}-sns-topic"
  display_name = "${var.name}-sns-topic"
}

module "asg_alarms" {
  source = "../"

  autoscaling_group_name = module.asg.this_autoscaling_group_id
  prefix                 = "${var.name}-alarms"

  in_service_evaluation_periods      = "3"
  in_service_statistic_period        = "60"
  expected_instances_in_service      = module.asg.this_autoscaling_group_desired_capacity
  in_pending_evaluation_periods      = "3"
  in_pending_statistic_period        = "60"
  in_standby_evaluation_periods      = "3"
  in_standby_statistic_period        = "60"
  in_terminating_evaluation_periods  = "3"
  in_terminating_statistic_period    = "60"
  total_instances_evaluation_periods = "3"
  total_instances_statistic_period   = "60"
  total_instances_in_service         = module.asg.this_autoscaling_group_desired_capacity

  actions_alarm = [
    module.sns_topic.this_sns_topic_arn
  ]
  actions_ok = [
    module.sns_topic.this_sns_topic_arn
  ]

  depends_on = [
    module.asg,
    module.sns_topic
  ]
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 0.3, < 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 0.3, < 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.healthy_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.pending_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.standby_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.terminating_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.total_instances_greater](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.total_instances_lower](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_actions_alarm"></a> [actions\_alarm](#input\_actions\_alarm) | A list of actions to take when alarms are triggered. Will likely be an SNS topic for event distribution. | `list` | `[]` | no |
| <a name="input_actions_ok"></a> [actions\_ok](#input\_actions\_ok) | A list of actions to take when alarms are cleared. Will likely be an SNS topic for event distribution. | `list` | `[]` | no |
| <a name="input_autoscaling_group_name"></a> [autoscaling\_group\_name](#input\_autoscaling\_group\_name) | ASG name to apply alarms to | `string` | n/a | yes |
| <a name="input_expected_instances_in_service"></a> [expected\_instances\_in\_service](#input\_expected\_instances\_in\_service) | Total number of instances expected to be healthy and in service | `string` | `"1"` | no |
| <a name="input_in_pending_evaluation_periods"></a> [in\_pending\_evaluation\_periods](#input\_in\_pending\_evaluation\_periods) | The number of data periods to evaluate before triggering an alert. | `string` | `"5"` | no |
| <a name="input_in_pending_statistic_period"></a> [in\_pending\_statistic\_period](#input\_in\_pending\_statistic\_period) | The length of a data period in seconds to evaluate the resource. | `string` | `"60"` | no |
| <a name="input_in_service_evaluation_periods"></a> [in\_service\_evaluation\_periods](#input\_in\_service\_evaluation\_periods) | The number of data periods to evaluate before triggering an alert. | `string` | `"5"` | no |
| <a name="input_in_service_statistic_period"></a> [in\_service\_statistic\_period](#input\_in\_service\_statistic\_period) | The length of a data period in seconds to evaluate the resource. | `string` | `"60"` | no |
| <a name="input_in_standby_evaluation_periods"></a> [in\_standby\_evaluation\_periods](#input\_in\_standby\_evaluation\_periods) | The number of data periods to evaluate before triggering an alert. | `string` | `"5"` | no |
| <a name="input_in_standby_statistic_period"></a> [in\_standby\_statistic\_period](#input\_in\_standby\_statistic\_period) | The length of a data period in seconds to evaluate the resource. | `string` | `"60"` | no |
| <a name="input_in_terminating_evaluation_periods"></a> [in\_terminating\_evaluation\_periods](#input\_in\_terminating\_evaluation\_periods) | The number of data periods to evaluate before triggering an alert. | `string` | `"5"` | no |
| <a name="input_in_terminating_statistic_period"></a> [in\_terminating\_statistic\_period](#input\_in\_terminating\_statistic\_period) | The length of a data period in seconds to evaluate the resource. | `string` | `"60"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Alarm Name Prefix | `string` | `"asg-alarms-"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to all taggable resources created by this module. | `map(string)` | `{}` | no |
| <a name="input_total_instances_evaluation_periods"></a> [total\_instances\_evaluation\_periods](#input\_total\_instances\_evaluation\_periods) | The number of data periods to evaluate before triggering an alert. | `string` | `"5"` | no |
| <a name="input_total_instances_in_service"></a> [total\_instances\_in\_service](#input\_total\_instances\_in\_service) | The length of a data period in seconds to evaluate the resource. | `string` | `"1"` | no |
| <a name="input_total_instances_statistic_period"></a> [total\_instances\_statistic\_period](#input\_total\_instances\_statistic\_period) | The length of a data period in seconds to evaluate the resource. | `string` | `"60"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_healthy_instances"></a> [healthy\_instances](#output\_healthy\_instances) | The CloudWatch Metric Alarm resource instances in service |
| <a name="output_pending_instances"></a> [pending\_instances](#output\_pending\_instances) | The CloudWatch Metric Alarm resource instances in pending |
| <a name="output_standby_instances"></a> [standby\_instances](#output\_standby\_instances) | The CloudWatch Metric Alarm resource instances in standby |
| <a name="output_terminating_instances"></a> [terminating\_instances](#output\_terminating\_instances) | The CloudWatch Metric Alarm resource instances in terminating |
| <a name="output_total_instances_greater"></a> [total\_instances\_greater](#output\_total\_instances\_greater) | The CloudWatch Metric Alarm resource for total instances |
| <a name="output_total_instances_lower"></a> [total\_instances\_lower](#output\_total\_instances\_lower) | The CloudWatch Metric Alarm resource for total instances |
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

- Raja Tatapudi

> This project was generated by [generator-tf-module](https://github.com/sudokar/generator-tf-module)
