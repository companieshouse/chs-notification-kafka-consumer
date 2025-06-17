# ------------------------------------------------------------------------------
# CHIPS Security Group and rules
# ------------------------------------------------------------------------------
module "asg_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.3"

  name        = "sgr-${var.application}-asg-001"
  description = "Security group for the ${var.application} asg"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = local.admin_cidrs
  ingress_rules       = ["ssh-tcp"]

  ingress_with_cidr_blocks = var.additional_ingress_with_cidr_blocks

  ingress_with_source_security_group_id = concat([
    {
      from_port                = var.application_port
      to_port                  = var.application_port
      protocol                 = "tcp"
      description              = "${var.application} port"
      source_security_group_id = module.internal_alb_security_group.security_group_id
    },
    {
      from_port                = var.admin_port
      to_port                  = var.admin_port
      protocol                 = "tcp"
      description              = "${var.application} administration console port"
      source_security_group_id = module.internal_alb_security_group.security_group_id
    }], [for group in local.ssh_source_security_groups :
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      description              = "${var.application} SSH from ${group.name}"
      source_security_group_id = group.id
    }
  ])

  egress_rules = ["all-all"]
}

# ASG Module
module "asg" {
  source = "git@github.com:companieshouse/terraform-modules//aws/autoscaling-with-launch-template?ref=tags/1.0.287"

  count = var.asg_count

  name = format("%s%s", var.application, count.index)

  # Launch template
  lt_name       = format("%s%s-launchtemplate", var.application, count.index)
  image_id      = data.aws_ami.ami.id
  instance_type = var.instance_size
  security_groups = [
    module.asg_security_group.security_group_id,
    data.aws_security_group.nagios_shared.id
  ]
  root_block_device = [
    {
      volume_size = var.instance_root_volume_size
      encrypted   = true
    }
  ]
  block_device_mappings = [
    {
      device_name = "/dev/xvdb"
      encrypted   = true
      volume_size = var.instance_swap_volume_size
    }
  ]

  # Auto scaling group
  asg_name                       = format("%s%s-asg", var.application, count.index)
  vpc_zone_identifier            = data.aws_subnets.application.ids
  health_check_type              = "EC2"
  min_size                       = var.asg_min_size
  max_size                       = var.asg_max_size
  desired_capacity               = var.asg_desired_capacity
  health_check_grace_period      = 300
  wait_for_capacity_timeout      = 0
  force_delete                   = true
  enable_instance_refresh        = var.enable_instance_refresh
  refresh_min_healthy_percentage = 50
  refresh_triggers               = []
  key_name                       = aws_key_pair.keypair.key_name
  termination_policies           = ["OldestLaunchConfiguration"]
  enforce_imdsv2                 = var.enforce_imdsv2
  target_group_arns = var.create_app_target_group ? [
    module.internal_alb.target_group_arns[0],
    module.internal_alb.target_group_arns[count.index + 1]
    ] : [
    module.internal_alb.target_group_arns[count.index]
  ]
  iam_instance_profile = module.instance_profile.aws_iam_instance_profile.name
  user_data_base64     = data.template_cloudinit_config.userdata_config.rendered

  tags_as_map = merge(
    local.default_tags,
    tomap({
      app-instance-name = var.app_instance_name_override != null ? var.app_instance_name_override : format("%s%s", var.application, count.index)
      config-base-path  = var.config_base_path_override != null ? format("s3://%s/%s", var.config_bucket_name, var.config_base_path_override) : format("s3://%s/%s-configs/%s", var.config_bucket_name, var.application, var.environment)
    })
  )
}

resource "aws_cloudwatch_log_group" "log_groups" {
  for_each = local.cloudwatch_logs

  name              = each.value["log_group_name"]
  retention_in_days = lookup(each.value, "log_group_retention", var.default_log_group_retention_in_days)
  kms_key_id        = lookup(each.value, "kms_key_id", local.logs_kms_key_id)
}

#--------------------------------------------
# ASG CloudWatch Alarms
#--------------------------------------------
module "asg_alarms" {
  source = "git@github.com:companieshouse/terraform-modules//aws/asg-cloudwatch-alarms?ref=tags/1.0.288"

  count = var.asg_count

  autoscaling_group_name = module.asg[count.index].this_autoscaling_group_name
  prefix                 = "${var.aws_account}-${var.application}-${count.index}-asg-alarms"

  in_service_evaluation_periods      = "1"
  in_service_statistic_period        = "60"
  expected_instances_in_service      = 1
  in_pending_evaluation_periods      = "3"
  in_pending_statistic_period        = "120"
  in_standby_evaluation_periods      = "3"
  in_standby_statistic_period        = "120"
  in_terminating_evaluation_periods  = "3"
  in_terminating_statistic_period    = "120"
  total_instances_evaluation_periods = "1"
  total_instances_statistic_period   = "120"
  total_instances_in_service         = 1

  actions_alarm = var.enable_sns_topic ? [module.cloudwatch_sns_email[0].sns_topic_arn, module.cloudwatch_sns_ooh[0].sns_topic_arn] : []
  actions_ok    = var.enable_sns_topic ? [module.cloudwatch_sns_email[0].sns_topic_arn, module.cloudwatch_sns_ooh[0].sns_topic_arn] : []


  depends_on = [
    module.cloudwatch_sns_email,
    module.asg
  ]
}

#--------------------------------------------
# EC2 CloudWatch Alarms at ASG level
#--------------------------------------------
resource "aws_cloudwatch_metric_alarm" "ec2-cpu-utilization-high" {

  count = var.asg_count

  alarm_name          = "${var.aws_account}-${var.application}-${count.index}-EC2-CPUUtilization-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Maximum"
  threshold           = "90"
  treat_missing_data  = "notBreaching"
  alarm_actions       = var.enable_sns_topic ? [module.cloudwatch_sns_email[0].sns_topic_arn, module.cloudwatch_sns_ooh[0].sns_topic_arn] : []
  ok_actions          = var.enable_sns_topic ? [module.cloudwatch_sns_email[0].sns_topic_arn, module.cloudwatch_sns_ooh[0].sns_topic_arn] : []

  dimensions = {
    AutoScalingGroupName = module.asg[count.index].this_autoscaling_group_name
  }

  alarm_description = "${var.aws_account}: CPU use high for ${var.application} EC2 instance in ASG ${module.asg[count.index].this_autoscaling_group_name}"

  lifecycle {
    ignore_changes = [
      alarm_actions,
      ok_actions,
      insufficient_data_actions
    ]
  }
  depends_on = [
    module.cloudwatch_sns_email,
    module.asg
  ]
}

resource "aws_cloudwatch_metric_alarm" "ec2-mem-used-percent-high" {

  count = var.asg_count

  alarm_name          = "${var.aws_account}-${var.application}-${count.index}-EC2-MemUsedPercent-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "CHIPS"
  period              = "120"
  statistic           = "Maximum"
  threshold           = var.cloudwatch_memory_alarm_threshold
  treat_missing_data  = "notBreaching"
  alarm_actions       = var.enable_sns_topic ? [module.cloudwatch_sns_email[0].sns_topic_arn, module.cloudwatch_sns_ooh[0].sns_topic_arn] : []
  ok_actions          = var.enable_sns_topic ? [module.cloudwatch_sns_email[0].sns_topic_arn, module.cloudwatch_sns_ooh[0].sns_topic_arn] : []

  dimensions = {
    AutoScalingGroupName = module.asg[count.index].this_autoscaling_group_name
  }

  alarm_description = "${var.aws_account}: Memory use high for ${var.application} EC2 instance in ASG ${module.asg[count.index].this_autoscaling_group_name}"

  lifecycle {
    ignore_changes = [
      alarm_actions,
      ok_actions,
      insufficient_data_actions
    ]
  }
  depends_on = [
    module.cloudwatch_sns_email,
    module.asg
  ]
}

resource "aws_cloudwatch_metric_alarm" "ec2-disk-used-percent-high" {

  count = var.asg_count

  alarm_name          = "${var.aws_account}-${var.application}-${count.index}-EC2-DiskUsedPercent-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "disk_used_percent"
  namespace           = "CHIPS"
  period              = "120"
  statistic           = "Maximum"
  threshold           = "90"
  treat_missing_data  = "notBreaching"
  alarm_actions       = var.enable_sns_topic ? [module.cloudwatch_sns_email[0].sns_topic_arn, module.cloudwatch_sns_ooh[0].sns_topic_arn] : []
  ok_actions          = var.enable_sns_topic ? [module.cloudwatch_sns_email[0].sns_topic_arn, module.cloudwatch_sns_ooh[0].sns_topic_arn] : []

  dimensions = {
    AutoScalingGroupName = module.asg[count.index].this_autoscaling_group_name
  }

  alarm_description = "${var.aws_account}: Disk use high for ${var.application} EC2 instance in ASG ${module.asg[count.index].this_autoscaling_group_name}"

  lifecycle {
    ignore_changes = [
      alarm_actions,
      ok_actions,
      insufficient_data_actions
    ]
  }
  depends_on = [
    module.cloudwatch_sns_email,
    module.asg
  ]
}

# ASG Scheduled Shutdown
resource "aws_autoscaling_schedule" "stop" {
  count = var.shutdown_schedule != null ? var.asg_count : 0

  scheduled_action_name  = "${var.application}${count.index}-scheduled-shutdown"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = var.shutdown_schedule
  time_zone              = "Europe/London"
  autoscaling_group_name = module.asg[count.index].this_autoscaling_group_name
}

# ASG Scheduled Startup
resource "aws_autoscaling_schedule" "start" {
  count = var.startup_schedule != null ? var.asg_count : 0

  scheduled_action_name  = "${var.application}${count.index}-scheduled-startup"
  min_size               = var.asg_min_size
  max_size               = var.asg_max_size
  desired_capacity       = var.asg_desired_capacity
  recurrence             = var.startup_schedule
  time_zone              = "Europe/London"
  autoscaling_group_name = module.asg[count.index].this_autoscaling_group_name
}
