<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 0.3, < 6.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 0.3, < 6.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 2.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_asg"></a> [asg](#module\_asg) | git@github.com:companieshouse/terraform-modules//aws/autoscaling-with-launch-template | tags/1.0.287 |
| <a name="module_asg_alarms"></a> [asg\_alarms](#module\_asg\_alarms) | git@github.com:companieshouse/terraform-modules//aws/asg-cloudwatch-alarms | tags/1.0.288 |
| <a name="module_asg_security_group"></a> [asg\_security\_group](#module\_asg\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.3 |
| <a name="module_cloudwatch_sns_email"></a> [cloudwatch\_sns\_email](#module\_cloudwatch\_sns\_email) | terraform-aws-modules/sns/aws | 3.3.0 |
| <a name="module_cloudwatch_sns_ooh"></a> [cloudwatch\_sns\_ooh](#module\_cloudwatch\_sns\_ooh) | terraform-aws-modules/sns/aws | 3.3.0 |
| <a name="module_instance_profile"></a> [instance\_profile](#module\_instance\_profile) | git@github.com:companieshouse/terraform-modules//aws/instance_profile | tags/1.0.287 |
| <a name="module_internal_alb"></a> [internal\_alb](#module\_internal\_alb) | terraform-aws-modules/alb/aws | ~> 6.5 |
| <a name="module_internal_alb_alarms"></a> [internal\_alb\_alarms](#module\_internal\_alb\_alarms) | git@github.com:companieshouse/terraform-modules//aws/alb-cloudwatch-alarms | tags/1.0.288 |
| <a name="module_internal_alb_security_group"></a> [internal\_alb\_security\_group](#module\_internal\_alb\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.3 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_schedule.start](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_autoscaling_schedule.stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_cloudwatch_log_group.log_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.ec2-cpu-utilization-high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2-disk-used-percent-high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2-mem-used-percent-high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_role_policy_attachment.inspector_cis_scanning_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_lb.nlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.nlb_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.nlb_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.nlb_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.nlb_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.alb_to_nlb_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.alb_to_nlb_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_route53_record.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.nlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_acm_certificate.acm_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_ami.ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_route53_zone.private_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_security_group.nagios_shared](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_security_group.ssh_access_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnet.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [template_cloudinit_config.userdata_config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config) | data source |
| [template_file.userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [vault_generic_secret.account_ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.chs_cidrs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.client_cidrs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.ec2_data](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.internal_cidrs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.nlb_subnet_mappings](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_s3_buckets](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.test_cidrs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_ingress_with_cidr_blocks"></a> [additional\_ingress\_with\_cidr\_blocks](#input\_additional\_ingress\_with\_cidr\_blocks) | Additional ingress rules that can be set from outside of this module | `list(map(string))` | `[]` | no |
| <a name="input_additional_userdata_prefix"></a> [additional\_userdata\_prefix](#input\_additional\_userdata\_prefix) | Additional userdata prefix, will be executed before all other userdata and server configuration via Ansible | `string` | `""` | no |
| <a name="input_additional_userdata_suffix"></a> [additional\_userdata\_suffix](#input\_additional\_userdata\_suffix) | Additional userdata suffix, will be executed after server configuration via Ansible | `string` | `""` | no |
| <a name="input_admin_health_check_path"></a> [admin\_health\_check\_path](#input\_admin\_health\_check\_path) | Target group health check path for administration console | `string` | `"/console"` | no |
| <a name="input_admin_port"></a> [admin\_port](#input\_admin\_port) | Target group backend port for administration | `number` | `21001` | no |
| <a name="input_alb_deletion_protection"></a> [alb\_deletion\_protection](#input\_alb\_deletion\_protection) | Enable or disable deletion protection for instances | `bool` | `false` | no |
| <a name="input_alb_idle_timeout"></a> [alb\_idle\_timeout](#input\_alb\_idle\_timeout) | The idle connection timeout in seconds | `number` | `60` | no |
| <a name="input_ami_name"></a> [ami\_name](#input\_ami\_name) | Name of the AMI to use in the Auto Scaling configuration | `string` | `"docker-ami-*"` | no |
| <a name="input_app_instance_name_override"></a> [app\_instance\_name\_override](#input\_app\_instance\_name\_override) | An alternative value to set for the app-instance-name tag on the EC2 instances. | `string` | `null` | no |
| <a name="input_application"></a> [application](#input\_application) | The component name of the application | `string` | n/a | yes |
| <a name="input_application_health_check_path"></a> [application\_health\_check\_path](#input\_application\_health\_check\_path) | Target group health check path for application | `string` | `"/chips/cff"` | no |
| <a name="input_application_port"></a> [application\_port](#input\_application\_port) | Target group backend port for application | `number` | `21000` | no |
| <a name="input_application_type"></a> [application\_type](#input\_application\_type) | The parent name of the application | `string` | `"chips"` | no |
| <a name="input_asg_count"></a> [asg\_count](#input\_asg\_count) | The number of ASGs - typically 1 for dev and 2 for staging/live | `number` | n/a | yes |
| <a name="input_asg_desired_capacity"></a> [asg\_desired\_capacity](#input\_asg\_desired\_capacity) | The desired capacity of ASG - always 1 | `number` | `1` | no |
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | The max size of the ASG - always 1 | `number` | `1` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | The min size of the ASG - always 1 | `number` | `1` | no |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_cloudwatch_logs"></a> [cloudwatch\_logs](#input\_cloudwatch\_logs) | Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging | `map(any)` | `{}` | no |
| <a name="input_cloudwatch_memory_alarm_threshold"></a> [cloudwatch\_memory\_alarm\_threshold](#input\_cloudwatch\_memory\_alarm\_threshold) | The threshold for the ASG's alarm on the EC2 metric mem\_used\_percent | `number` | `95` | no |
| <a name="input_cloudwatch_namespace"></a> [cloudwatch\_namespace](#input\_cloudwatch\_namespace) | A custom namespace to define for CloudWatch custom metrics such as memory and disk | `string` | `"CHIPS"` | no |
| <a name="input_config_base_path_override"></a> [config\_base\_path\_override](#input\_config\_base\_path\_override) | An alternative value to set for the config-base-path tag on the EC2 instances. The value supplied is prefixed with the config\_bucket\_name var. | `string` | `null` | no |
| <a name="input_config_bucket_name"></a> [config\_bucket\_name](#input\_config\_bucket\_name) | Bucket name the application will use to retrieve configuration files | `string` | `""` | no |
| <a name="input_create_app_target_group"></a> [create\_app\_target\_group](#input\_create\_app\_target\_group) | Enable or disable the creation of a target group for the chips app | `bool` | `true` | no |
| <a name="input_create_nlb"></a> [create\_nlb](#input\_create\_nlb) | Enable or disable the creation of a nlb that fronts the alb to provide static ips | `bool` | `false` | no |
| <a name="input_default_log_group_retention_in_days"></a> [default\_log\_group\_retention\_in\_days](#input\_default\_log\_group\_retention\_in\_days) | Total days to retain logs in CloudWatch log group if not specified for specific logs | `number` | `14` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain Name for ACM Certificate | `string` | `"*.companieshouse.gov.uk"` | no |
| <a name="input_enable_instance_refresh"></a> [enable\_instance\_refresh](#input\_enable\_instance\_refresh) | Enable or disable instance refresh when the ASG is updated | `bool` | `true` | no |
| <a name="input_enable_sns_topic"></a> [enable\_sns\_topic](#input\_enable\_sns\_topic) | A boolean value to indicate whether to deploy SNS topic configuration for CloudWatch actions | `bool` | `false` | no |
| <a name="input_enforce_imdsv2"></a> [enforce\_imdsv2](#input\_enforce\_imdsv2) | Whether to enforce use of IMDSv2 by setting http\_tokens to required on the aws\_launch\_template | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_instance_root_volume_size"></a> [instance\_root\_volume\_size](#input\_instance\_root\_volume\_size) | Size of root volume attached to instances | `number` | `40` | no |
| <a name="input_instance_size"></a> [instance\_size](#input\_instance\_size) | The size of the ec2 instances to build | `string` | n/a | yes |
| <a name="input_instance_swap_volume_size"></a> [instance\_swap\_volume\_size](#input\_instance\_swap\_volume\_size) | Size of swap volume attached to instances | `number` | `5` | no |
| <a name="input_maximum_4xx_threshold"></a> [maximum\_4xx\_threshold](#input\_maximum\_4xx\_threshold) | Threshold for number of 4xx errors | `number` | `2` | no |
| <a name="input_maximum_5xx_threshold"></a> [maximum\_5xx\_threshold](#input\_maximum\_5xx\_threshold) | Threshold for number of 5xx errors | `number` | `2` | no |
| <a name="input_nfs_mount_destination_parent_dir"></a> [nfs\_mount\_destination\_parent\_dir](#input\_nfs\_mount\_destination\_parent\_dir) | The parent folder that all NFS shares should be mounted inside on the EC2 instance | `string` | `"/mnt"` | no |
| <a name="input_nfs_mounts"></a> [nfs\_mounts](#input\_nfs\_mounts) | A map of objects which contains mount details for each mount path required. | `any` | n/a | yes |
| <a name="input_nfs_server"></a> [nfs\_server](#input\_nfs\_server) | The name or IP of the environment specific NFS server | `string` | `null` | no |
| <a name="input_short_account"></a> [short\_account](#input\_short\_account) | Short version of the name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_short_region"></a> [short\_region](#input\_short\_region) | Short version of the name of the AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_shutdown_schedule"></a> [shutdown\_schedule](#input\_shutdown\_schedule) | Cron expression for the shutdown time - e.g. '00 20 * * 1-5' is 8pm Mon-Fri | `string` | `null` | no |
| <a name="input_ssh_access_security_group_patterns"></a> [ssh\_access\_security\_group\_patterns](#input\_ssh\_access\_security\_group\_patterns) | List of source security group name patterns that will have SSH access | `list(string)` | <pre>[<br>  "sgr-chips-control-asg-001-*"<br>]</pre> | no |
| <a name="input_startup_schedule"></a> [startup\_schedule](#input\_startup\_schedule) | Cron expression for the startup time - e.g. '00 06 * * 1-5' is 6am Mon-Fri | `string` | `null` | no |
| <a name="input_test_access_enable"></a> [test\_access\_enable](#input\_test\_access\_enable) | Controls whether access from the Test subnets is required (true) or not (false) | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_address_internal"></a> [admin\_address\_internal](#output\_admin\_address\_internal) | n/a |
| <a name="output_app_address_internal"></a> [app\_address\_internal](#output\_app\_address\_internal) | n/a |
| <a name="output_application_subnets"></a> [application\_subnets](#output\_application\_subnets) | n/a |
<!-- END_TF_DOCS -->