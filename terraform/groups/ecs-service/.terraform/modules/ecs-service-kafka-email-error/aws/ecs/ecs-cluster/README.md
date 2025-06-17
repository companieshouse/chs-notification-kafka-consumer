<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.3.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.54.0 |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | >= 2.3.3 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 3.18.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.54.0 |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | >= 2.3.3 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 3.18.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudwatch_sns_alerting_notify_topic"></a> [cloudwatch\_sns\_alerting\_notify\_topic](#module\_cloudwatch\_sns\_alerting\_notify\_topic) | terraform-aws-modules/sns/aws | 5.0.0 |
| <a name="module_cloudwatch_sns_alerting_ooh_topic"></a> [cloudwatch\_sns\_alerting\_ooh\_topic](#module\_cloudwatch\_sns\_alerting\_ooh\_topic) | terraform-aws-modules/sns/aws | 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.ecs-autoscaling-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_schedule.schedule-scaledown](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_autoscaling_schedule.schedule-scaleup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_ecs_capacity_provider.ec2_capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_cluster.ecs-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.ecs_cluster_capacity_providers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_iam_instance_profile.ecs-instance-profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ecs-instance-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs-service-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs-task-execution-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.cloudwatch-logs-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ecs-secrets-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ecs-task-execution-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ecs_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.iam-pass-role-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ssm_logging_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ecs-instance-role-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs-service-role-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs-task-execution-role-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_instance_role_cis_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_instance_role_ssm_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.ec2_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.ec2_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_launch_template.ecs_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.ec2-security-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_sns_topic_subscription.notify_topic_slack_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ec2_managed_prefix_list.administration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_iam_policy_document.ec2_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs-instance-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs-service-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs-task-execution-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ssm_logging_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_subnet.alb_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.alb_subnet_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [cloudinit_config.userdata_config](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |
| [vault_generic_secret.security_kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_s3_buckets](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.shared_s3](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_subnet_patterns"></a> [alb\_subnet\_patterns](#input\_alb\_subnet\_patterns) | List of subnet name patterns that will be allowed access to the application ports.  These should normally be the ALB subnets and the default is the CHS subnets in dev, staging and live. | `list(string)` | <pre>[<br>  "development-mm-platform-applications-*",<br>  "development-mm-platform-public-*",<br>  "development-mm-platform-routing-*",<br>  "staging-ch-platform-applications-*",<br>  "staging-ch-platform-public-*",<br>  "staging-ch-platform-routing-*",<br>  "live-mm-platform-applications-*",<br>  "live-mm-platform-public-*",<br>  "live-mm-platform-routing-*"<br>]</pre> | no |
| <a name="input_asg_desired_instance_count"></a> [asg\_desired\_instance\_count](#input\_asg\_desired\_instance\_count) | The desired number of instances in the autoscaling group for the cluster. Must fall within the min/max instance count range. | `number` | `2` | no |
| <a name="input_asg_max_instance_count"></a> [asg\_max\_instance\_count](#input\_asg\_max\_instance\_count) | The maximum allowed number of instances in the autoscaling group for the cluster. | `number` | `3` | no |
| <a name="input_asg_min_instance_count"></a> [asg\_min\_instance\_count](#input\_asg\_min\_instance\_count) | The minimum allowed number of instances in the autoscaling group for the cluster. | `number` | `1` | no |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS profile to use for deployment. | `string` | n/a | yes |
| <a name="input_create_sns_notify_topic"></a> [create\_sns\_notify\_topic](#input\_create\_sns\_notify\_topic) | Whether to create an SNS notify topic for this cluster, which can be used by alarms to trigger notifications. | `bool` | `true` | no |
| <a name="input_create_sns_ooh_topic"></a> [create\_sns\_ooh\_topic](#input\_create\_sns\_ooh\_topic) | Whether to create an SNS out of hours topic for this cluster, which can be used by alarms to trigger alerts. | `bool` | `true` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | A map of default tags to be added to the resources | `map(any)` | `{}` | no |
| <a name="input_ec2_enable_ssm_logging"></a> [ec2\_enable\_ssm\_logging](#input\_ec2\_enable\_ssm\_logging) | Whether to add a policy to allow centralised logging to the security account for SSM sessions. | `bool` | `true` | no |
| <a name="input_ec2_enforce_imdsv2"></a> [ec2\_enforce\_imdsv2](#input\_ec2\_enforce\_imdsv2) | Whether to enforce use of IMDSv2 by setting http\_tokens to required on the aws\_launch\_template | `bool` | `true` | no |
| <a name="input_ec2_image_id"></a> [ec2\_image\_id](#input\_ec2\_image\_id) | The machine image to use when launching EC2 instances. | `string` | `"ami-01255d13f656c60b9"` | no |
| <a name="input_ec2_ingress_cidr_blocks"></a> [ec2\_ingress\_cidr\_blocks](#input\_ec2\_ingress\_cidr\_blocks) | Comma separated list of additional ingress CIDR ranges to allow access to application ports. | `string` | `null` | no |
| <a name="input_ec2_ingress_sg_id"></a> [ec2\_ingress\_sg\_id](#input\_ec2\_ingress\_sg\_id) | The security groups from which to allow access to port 80. | `list(string)` | `[]` | no |
| <a name="input_ec2_instance_type"></a> [ec2\_instance\_type](#input\_ec2\_instance\_type) | The ec2 instance type for ec2 instances in the clusters auto scaling group. | `string` | `"t3.micro"` | no |
| <a name="input_ec2_key_pair_name"></a> [ec2\_key\_pair\_name](#input\_ec2\_key\_pair\_name) | The ec2 key pair name for SSH access to ec2 instances in the clusters auto scaling group. | `string` | `""` | no |
| <a name="input_ec2_root_block_device"></a> [ec2\_root\_block\_device](#input\_ec2\_root\_block\_device) | Customize details about the root block device of the instance, apart from encryption which is always enabled and uses a cluster specific KMS key. | `map(string)` | <pre>{<br>  "volume_type": "gp3"<br>}</pre> | no |
| <a name="input_enable_asg_autoscaling"></a> [enable\_asg\_autoscaling](#input\_enable\_asg\_autoscaling) | Whether to enable auto-scaling of the ASG by creating a capacity provider for the ECS cluster. | `bool` | `false` | no |
| <a name="input_enable_container_insights"></a> [enable\_container\_insights](#input\_enable\_container\_insights) | A boolean value indicating whether to enable Container Insights or not | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment this cluster is part of e.g. live, staging, dev. etc. | `string` | n/a | yes |
| <a name="input_maximum_scaling_step_size"></a> [maximum\_scaling\_step\_size](#input\_maximum\_scaling\_step\_size) | The maximum number of Amazon EC2 instances that Amazon ECS will scale out at one time.  Total is limited by asg\_max\_instance\_count too. | `number` | `150` | no |
| <a name="input_minimum_scaling_step_size"></a> [minimum\_scaling\_step\_size](#input\_minimum\_scaling\_step\_size) | The minimum number of Amazon EC2 instances that Amazon ECS will scale out at one time. | `number` | `1` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The prefix to use when naming resources in this cluster. Usually a combination of environment and stack\_name for concistency e.g. '{stack\_name}-{environment}'. | `string` | n/a | yes |
| <a name="input_notify_topic_slack_endpoint"></a> [notify\_topic\_slack\_endpoint](#input\_notify\_topic\_slack\_endpoint) | The webhook URL of the Slack endpoint that will be automatically subscribed to the topic. If left blank, no subscription will be created. | `string` | `""` | no |
| <a name="input_scaledown_schedule"></a> [scaledown\_schedule](#input\_scaledown\_schedule) | The schedule to use when scaling down the number of EC2 instances to zero. | `string` | `""` | no |
| <a name="input_scaleup_schedule"></a> [scaleup\_schedule](#input\_scaleup\_schedule) | The schedule to use when scaling up the number of EC2 instances to their normal desired level. | `string` | `""` | no |
| <a name="input_stack_name"></a> [stack\_name](#input\_stack\_name) | The name of the infrastructure 'stack' this cluster is part of. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Comma seperated list of subnet ids to deploy the cluster into. | `string` | n/a | yes |
| <a name="input_target_capacity"></a> [target\_capacity](#input\_target\_capacity) | The target capacity utilization as a percentage for the capacity provider. | `number` | `100` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC to deploy resources into. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_cluster_autoscalinggroup_arn"></a> [ecs\_cluster\_autoscalinggroup\_arn](#output\_ecs\_cluster\_autoscalinggroup\_arn) | n/a |
| <a name="output_ecs_cluster_id"></a> [ecs\_cluster\_id](#output\_ecs\_cluster\_id) | ECS module outputs |
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | n/a |
| <a name="output_ecs_cluster_sg_id"></a> [ecs\_cluster\_sg\_id](#output\_ecs\_cluster\_sg\_id) | n/a |
| <a name="output_ecs_instance_profile_name"></a> [ecs\_instance\_profile\_name](#output\_ecs\_instance\_profile\_name) | n/a |
| <a name="output_ecs_instance_role_name"></a> [ecs\_instance\_role\_name](#output\_ecs\_instance\_role\_name) | n/a |
| <a name="output_ecs_service_role_arn"></a> [ecs\_service\_role\_arn](#output\_ecs\_service\_role\_arn) | n/a |
| <a name="output_ecs_task_execution_role_arn"></a> [ecs\_task\_execution\_role\_arn](#output\_ecs\_task\_execution\_role\_arn) | n/a |
<!-- END_TF_DOCS -->