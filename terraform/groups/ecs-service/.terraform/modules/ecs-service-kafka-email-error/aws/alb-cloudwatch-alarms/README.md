# alb-cloudwatch-alarms

## Overview

This module will create alarms for the Application Load balancer and Target Groups supplied.
If multiple target groups are provided then multiple alarms will be created via count for each target group/load balancer pairing.


## Usage

```hcl

module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 5.0"
  name               = "terratest-alb"
  load_balancer_type = "application"
  vpc_id             = data.aws_vpc.default.id
  subnets            = data.aws_subnet_ids.this.ids
  internal           = true

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    },
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTPS"
      backend_port     = 443
      target_type      = "instance"
    }
  ]
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
  tags = {
    Environment = "Test"
  }
}

module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 2.0"

  name         = "terratest-topic"
  display_name = "terratest-topic"
}

module "alb_alarms" {
  source = "../"

  alb_arn_suffix            = module.alb.this_lb_arn_suffix
  target_group_arn_suffixes = module.alb.target_group_arn_suffixes
  prefix                    = "terratestAlarm-"
  response_time_threshold   = "100"
  evaluation_periods        = "3"
  statistic_period          = "60"
  actions_alarm = [
    module.sns_topic.this_sns_topic_arn
  ]
  actions_ok = [
    module.sns_topic.this_sns_topic_arn
  ]
  maximum_4xx_threshold = "1"
  maximum_5xx_threshold = "1"

  depends_on = [
    module.alb,
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
| [aws_cloudwatch_metric_alarm.client_tls_neg_err_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.httpcode_lb_4xx_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.httpcode_lb_5xx_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.httpcode_target_4xx_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.httpcode_target_5xx_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.target_response_time_average](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.unhealthy_hosts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_actions_alarm"></a> [actions\_alarm](#input\_actions\_alarm) | A list of actions to take when alarms are triggered. Will likely be an SNS topic for event distribution. | `list` | `[]` | no |
| <a name="input_actions_ok"></a> [actions\_ok](#input\_actions\_ok) | A list of actions to take when alarms are cleared. Will likely be an SNS topic for event distribution. | `list` | `[]` | no |
| <a name="input_alb_arn_suffix"></a> [alb\_arn\_suffix](#input\_alb\_arn\_suffix) | ALB Id to apply alarms to | `string` | n/a | yes |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | The number of evaluation period over which to use when triggering alarms e.g. the check must trigger 3 times before an alarm is raised, this number is multipled by the statistic\_period value 3x60s = 180s in total before alarm is raised | `string` | `"5"` | no |
| <a name="input_maximum_4xx_threshold"></a> [maximum\_4xx\_threshold](#input\_maximum\_4xx\_threshold) | The maximum allowed 4xx errors before an alarm is triggered | `string` | `"0"` | no |
| <a name="input_maximum_5xx_threshold"></a> [maximum\_5xx\_threshold](#input\_maximum\_5xx\_threshold) | The maximum allowed 5xx errors before an alarm is triggered | `string` | `"0"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Alarm Name Prefix | `string` | `""` | no |
| <a name="input_response_time_threshold"></a> [response\_time\_threshold](#input\_response\_time\_threshold) | The average number of milliseconds that requests should complete within. | `string` | `"50"` | no |
| <a name="input_statistic_period"></a> [statistic\_period](#input\_statistic\_period) | The number of seconds that make each statistic period. | `string` | `"60"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to all taggable resources created by this module. | `map(string)` | `{}` | no |
| <a name="input_target_group_arn_suffixes"></a> [target\_group\_arn\_suffixes](#input\_target\_group\_arn\_suffixes) | Target Group suffix(es) to apply alarms to | `list` | `[]` | no |
| <a name="input_unhealthy_hosts_threshold"></a> [unhealthy\_hosts\_threshold](#input\_unhealthy\_hosts\_threshold) | Maximum number of allowed unhealthy hosts before alarm is triggered. | `string` | `"2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_client_tls_neg_err_count"></a> [alarm\_client\_tls\_neg\_err\_count](#output\_alarm\_client\_tls\_neg\_err\_count) | The CloudWatch Metric Alarm resource block for client tls negotiation error count |
| <a name="output_alarm_httpcode_lb_4xx_count"></a> [alarm\_httpcode\_lb\_4xx\_count](#output\_alarm\_httpcode\_lb\_4xx\_count) | The CloudWatch Metric Alarm resource block for load balancer httpcode target 4xx count |
| <a name="output_alarm_httpcode_lb_5xx_count"></a> [alarm\_httpcode\_lb\_5xx\_count](#output\_alarm\_httpcode\_lb\_5xx\_count) | The CloudWatch Metric Alarm resource block for load balancer httpcode target 5xx count |
| <a name="output_alarm_httpcode_target_4xx_count"></a> [alarm\_httpcode\_target\_4xx\_count](#output\_alarm\_httpcode\_target\_4xx\_count) | The CloudWatch Metric Alarm resource block for target httpcode target 4xx count |
| <a name="output_alarm_httpcode_target_5xx_count"></a> [alarm\_httpcode\_target\_5xx\_count](#output\_alarm\_httpcode\_target\_5xx\_count) | The CloudWatch Metric Alarm resource block for target httpcode target 5xx count |
| <a name="output_alarm_unhealthy_host_count"></a> [alarm\_unhealthy\_host\_count](#output\_alarm\_unhealthy\_host\_count) | The CloudWatch Metric Alarm resource block for unhealthy host count |
| <a name="output_target_response_time_average"></a> [target\_response\_time\_average](#output\_target\_response\_time\_average) | The CloudWatch Metric Alarm resource block for target response time |
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
