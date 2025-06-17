# Module: aws/alarms/ec2

## Overview

This module creates the following CloudWatch alarms in the AWS/EC2 namespace:

   CPUUtilization greater than or equal to threshold
   StatusCheckFailed_Instance greater than or equal to 1 (instance status check failed)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_actions_alarm"></a> [actions\_alarm](#input\_actions\_alarm) | A list of actions to take when alarms are triggered. Will likely be an SNS topic for event distribution. | `list` | `[]` | no |
| <a name="input_actions_ok"></a> [actions\_ok](#input\_actions\_ok) | A list of actions to take when alarms are cleared. Will likely be an SNS topic for event distribution. | `list` | `[]` | no |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | The number of evaluation period over which to use when triggering alarms e.g. the check must trigger 3 times before an alarm is raised, this number is multipled by the statistic\_period value 3x60s = 180s in total before alarm is raised | `string` | `"5"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Alarm Name Prefix | `string` | `""` | no |
| <a name="input_response_time_threshold"></a> [response\_time\_threshold](#input\_response\_time\_threshold) | The average number of milliseconds that requests should complete within. | `string` | `"50"` | no |
| <a name="input_statistic_period"></a> [statistic\_period](#input\_statistic\_period) | The number of seconds that make each statistic period. | `string` | `"60"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to all taggable resources created by this module. | `map(string)` | `{}` | no 