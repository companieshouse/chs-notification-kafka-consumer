
# AWS Auto Scaling Group (ASG) Terraform module

Terraform module which creates Auto Scaling resources on AWS, using a Launch Template.

These types of resources are supported:

* [Launch Template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template.html)
* [Auto Scaling Group](https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html)

## Terraform versions

Terraform >= 0.12.6

## Usage

```
module "asg" {
  source  = "git@github.com:companieshouse/terraform-modules//aws/autoscaling-with-launch-template?ref=tags/1.0.184"
  
  name = "service"

  # Launch template configuration
  lt_name = "example-lt"

  image_id        = "ami-ebd02392"
  instance_type   = "t2.micro"
  security_groups = ["sg-12345678"]

 block_device_mappings = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    }
  ]

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "example-asg"
  vpc_zone_identifier       = ["subnet-1235678", "subnet-87654321"]
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  tags_as_map = {
    extra_tag1 = "extra_value1"
    extra_tag2 = "extra_value2"
  }
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.41 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.41 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asg_name"></a> [asg\_name](#input\_asg\_name) | Creates a unique name for autoscaling group beginning with the specified prefix | `string` | `""` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Associate a public ip address with an instance in a VPC | `bool` | `false` | no |
| <a name="input_block_device_mappings"></a> [block\_device\_mappings](#input\_block\_device\_mappings) | Additional EBS block devices to attach to the instance | `list(map(string))` | `[]` | no |
| <a name="input_core_count"></a> [core\_count](#input\_core\_count) | The number of cores to configure.  A value of 0 will use the default for the instance type | `number` | `0` | no |
| <a name="input_default_cooldown"></a> [default\_cooldown](#input\_default\_cooldown) | The amount of time, in seconds, after a scaling activity completes before another scaling activity can start | `number` | `300` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | The number of Amazon EC2 instances that should be running in the group | `string` | n/a | yes |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | If true, the launched EC2 instance will be EBS-optimized | `bool` | `false` | no |
| <a name="input_enable_instance_refresh"></a> [enable\_instance\_refresh](#input\_enable\_instance\_refresh) | Enable the instance refresh option of AWS Auto Scaling groups | `bool` | `false` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Enables/disables detailed monitoring. This is enabled by default. | `bool` | `true` | no |
| <a name="input_enforce_imdsv2"></a> [enforce\_imdsv2](#input\_enforce\_imdsv2) | Whether to enforce use of IMDSv2 by setting http\_tokens to required on the aws\_launch\_template | `bool` | `false` | no |
| <a name="input_enabled_metrics"></a> [enabled\_metrics](#input\_enabled\_metrics) | A list of metrics to collect. The allowed values are GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances | `list(string)` | <pre>[<br>  "GroupMinSize",<br>  "GroupMaxSize",<br>  "GroupDesiredCapacity",<br>  "GroupInServiceInstances",<br>  "GroupPendingInstances",<br>  "GroupStandbyInstances",<br>  "GroupTerminatingInstances",<br>  "GroupTotalInstances"<br>]</pre> | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling | `bool` | `false` | no |
| <a name="input_health_check_grace_period"></a> [health\_check\_grace\_period](#input\_health\_check\_grace\_period) | Time (in seconds) after instance comes into service before checking health | `number` | `300` | no |
| <a name="input_health_check_type"></a> [health\_check\_type](#input\_health\_check\_type) | Controls how health checking is done. Values are - EC2 and ELB | `string` | n/a | yes |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | The IAM instance profile to associate with launched instances | `string` | `""` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The EC2 image ID to launch | `string` | `""` | no |
| <a name="input_imdsv2_hop_limit"></a> [imdsv2\_hop\_limit](#input\_imdsv2\_hop\_limit) | The number of network hops allowed for instance metadata requests.  For containers running on EC2 there will be at least 2 hops. | `number` | `2` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The size of instance to launch | `string` | `""` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The key name that should be used for the instance | `string` | `""` | no |
| <a name="input_load_balancers"></a> [load\_balancers](#input\_load\_balancers) | A list of elastic load balancer names to add to the autoscaling group names | `list(string)` | `[]` | no |
| <a name="input_lt_name"></a> [lt\_name](#input\_lt\_name) | Creates a unique name for the launch template beginning with the specified prefix | `string` | `""` | no |
| <a name="input_max_instance_lifetime"></a> [max\_instance\_lifetime](#input\_max\_instance\_lifetime) | The maximum amount of time, in seconds, that an instance can be in service, values must be either equal to 0 or between 604800 and 31536000 seconds. | `number` | `0` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum size of the auto scale group | `string` | n/a | yes |
| <a name="input_metrics_granularity"></a> [metrics\_granularity](#input\_metrics\_granularity) | The granularity to associate with the metrics to collect. The only valid value is 1Minute | `string` | `"1Minute"` | no |
| <a name="input_min_elb_capacity"></a> [min\_elb\_capacity](#input\_min\_elb\_capacity) | Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes | `number` | `0` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum size of the auto scale group | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the EC2 instance - set as a tag | `string` | n/a | yes |
| <a name="input_protect_from_scale_in"></a> [protect\_from\_scale\_in](#input\_protect\_from\_scale\_in) | Allows setting instance protection. The autoscaling group will not select instances with this setting for termination during scale in events. | `bool` | `false` | no |
| <a name="input_refresh_instance_warmup"></a> [refresh\_instance\_warmup](#input\_refresh\_instance\_warmup) | (Optional) Number of seconds to allow for the instance to fully build and warm up before it is ready to use, omitting uses the default asg healthcheck grace period | `number` | `null` | no |
| <a name="input_refresh_min_healthy_percentage"></a> [refresh\_min\_healthy\_percentage](#input\_refresh\_min\_healthy\_percentage) | (Optional) The amount of capacity in the Auto Scaling group that must remain healthy during an instance refresh to allow the operation to continue, as a percentage of the desired capacity of the Auto Scaling group. Defaults to 90 | `number` | `90` | no |
| <a name="input_refresh_triggers"></a> [refresh\_triggers](#input\_refresh\_triggers) | (Optional) Set of additional property names that will trigger an Instance Refresh. A refresh will always be triggered by a change in any of launch\_configuration, launch\_template, or mixed\_instances\_policy. | `set(string)` | <pre>[<br>  "launch_template"<br>]</pre> | no |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | Customize details about the root block device of the instance | `list(map(string))` | `[]` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security group IDs to assign to the launch configuration | `list(string)` | `[]` | no |
| <a name="input_service_linked_role_arn"></a> [service\_linked\_role\_arn](#input\_service\_linked\_role\_arn) | The ARN of the service-linked role that the ASG will use to call other AWS services. | `string` | `""` | no |
| <a name="input_suspended_processes"></a> [suspended\_processes](#input\_suspended\_processes) | A list of processes to suspend for the AutoScaling Group. The allowed values are Launch, Terminate, HealthCheck, ReplaceUnhealthy, AZRebalance, AlarmNotification, ScheduledActions, AddToLoadBalancer. Note that if you suspend either the Launch or Terminate process types, it can prevent your autoscaling group from functioning properly. | `list(string)` | `[]` | no |
| <a name="input_tags_as_map"></a> [tags\_as\_map](#input\_tags\_as\_map) | A map of tags and values in the same format as other resources accept. This will be converted into the non-standard format that the aws\_autoscaling\_group requires. | `map(string)` | `{}` | no |
| <a name="input_target_group_arns"></a> [target\_group\_arns](#input\_target\_group\_arns) | A list of aws\_alb\_target\_group ARNs, for use with Application Load Balancing | `list(string)` | `[]` | no |
| <a name="input_termination_policies"></a> [termination\_policies](#input\_termination\_policies) | A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default | `list(string)` | <pre>[<br>  "Default"<br>]</pre> | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user\_data\_base64 instead. | `string` | `null` | no |
| <a name="input_user_data_base64"></a> [user\_data\_base64](#input\_user\_data\_base64) | Can be used instead of user\_data to pass base64-encoded binary data directly. Use this instead of user\_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption. | `string` | `null` | no |
| <a name="input_vpc_zone_identifier"></a> [vpc\_zone\_identifier](#input\_vpc\_zone\_identifier) | A list of subnet IDs to launch resources in | `list(string)` | n/a | yes |
| <a name="input_wait_for_capacity_timeout"></a> [wait\_for\_capacity\_timeout](#input\_wait\_for\_capacity\_timeout) | A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior. | `string` | `"10m"` | no |
| <a name="input_wait_for_elb_capacity"></a> [wait\_for\_elb\_capacity](#input\_wait\_for\_elb\_capacity) | Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over min\_elb\_capacity behavior. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_autoscaling_group_arn"></a> [this\_autoscaling\_group\_arn](#output\_this\_autoscaling\_group\_arn) | The ARN for this AutoScaling Group |
| <a name="output_this_autoscaling_group_availability_zones"></a> [this\_autoscaling\_group\_availability\_zones](#output\_this\_autoscaling\_group\_availability\_zones) | The availability zones of the autoscale group |
| <a name="output_this_autoscaling_group_default_cooldown"></a> [this\_autoscaling\_group\_default\_cooldown](#output\_this\_autoscaling\_group\_default\_cooldown) | Time between a scaling activity and the succeeding scaling activity |
| <a name="output_this_autoscaling_group_desired_capacity"></a> [this\_autoscaling\_group\_desired\_capacity](#output\_this\_autoscaling\_group\_desired\_capacity) | The number of Amazon EC2 instances that should be running in the group |
| <a name="output_this_autoscaling_group_health_check_grace_period"></a> [this\_autoscaling\_group\_health\_check\_grace\_period](#output\_this\_autoscaling\_group\_health\_check\_grace\_period) | Time after instance comes into service before checking health |
| <a name="output_this_autoscaling_group_health_check_type"></a> [this\_autoscaling\_group\_health\_check\_type](#output\_this\_autoscaling\_group\_health\_check\_type) | EC2 or ELB. Controls how health checking is done |
| <a name="output_this_autoscaling_group_id"></a> [this\_autoscaling\_group\_id](#output\_this\_autoscaling\_group\_id) | The autoscaling group id |
| <a name="output_this_autoscaling_group_load_balancers"></a> [this\_autoscaling\_group\_load\_balancers](#output\_this\_autoscaling\_group\_load\_balancers) | The load balancer names associated with the autoscaling group |
| <a name="output_this_autoscaling_group_max_size"></a> [this\_autoscaling\_group\_max\_size](#output\_this\_autoscaling\_group\_max\_size) | The maximum size of the autoscale group |
| <a name="output_this_autoscaling_group_min_size"></a> [this\_autoscaling\_group\_min\_size](#output\_this\_autoscaling\_group\_min\_size) | The minimum size of the autoscale group |
| <a name="output_this_autoscaling_group_name"></a> [this\_autoscaling\_group\_name](#output\_this\_autoscaling\_group\_name) | The autoscaling group name |
| <a name="output_this_autoscaling_group_target_group_arns"></a> [this\_autoscaling\_group\_target\_group\_arns](#output\_this\_autoscaling\_group\_target\_group\_arns) | List of Target Group ARNs that apply to this AutoScaling Group |
| <a name="output_this_autoscaling_group_vpc_zone_identifier"></a> [this\_autoscaling\_group\_vpc\_zone\_identifier](#output\_this\_autoscaling\_group\_vpc\_zone\_identifier) | The VPC zone identifier |
| <a name="output_this_launch_template_id"></a> [this\_launch\_template\_id](#output\_this\_launch\_template\_id) | The ID of the launch template |
| <a name="output_this_launch_template_name"></a> [this\_launch\_template\_name](#output\_this\_launch\_template\_name) | The name of the launch template |

## Examples

* [Auto Scaling Group without ELB](https://github.com/companieshouse/chips-devtest-terraform/groups/weblogic-infrastructure/asg.tf)

## License

Apache 2 Licensed. See LICENSE for full details.