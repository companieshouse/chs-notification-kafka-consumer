variable "name" {
  description = "Name of the EC2 instance - set as a tag"
  type        = string
}

variable "lt_name" {
  description = "Creates a unique name for the launch template beginning with the specified prefix"
  type        = string
  default     = ""
}

variable "asg_name" {
  description = "Creates a unique name for autoscaling group beginning with the specified prefix"
  type        = string
  default     = ""
}

# Launch template configuration
variable "image_id" {
  description = "The EC2 image ID to launch"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The size of instance to launch"
  type        = string
  default     = ""
}

variable "core_count" {
  description = "The number of cores to configure.  A value of 0 will use the default for the instance type"
  type        = number
  default     = 0
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with launched instances"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "The key name that should be used for the instance"
  type        = string
  default     = ""
}

variable "security_groups" {
  description = "A list of security group IDs to assign to the launch configuration"
  type        = list(string)
  default     = []
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead."
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption."
  type        = string
  default     = null
}

variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring. This is enabled by default."
  type        = bool
  default     = true
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = false
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance"
  type        = list(map(string))
  default     = []
}

variable "block_device_mappings" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(map(string))
  default     = []
}

variable "enforce_imdsv2" {
  description = "Whether to enforce use of IMDSv2 by setting http_tokens to required on the aws_launch_template"
  type        = bool
  default     = false
}

variable "imdsv2_hop_limit" {
  description = "The number of network hops allowed for instance metadata requests.  For containers running on EC2 there will be at least 2 hops."
  type        = number
  default     = 2
}

# Autoscaling group
variable "max_size" {
  description = "The maximum size of the auto scale group"
  type        = string
}

variable "min_size" {
  description = "The minimum size of the auto scale group"
  type        = string
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  type        = string
}

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs to launch resources in"
  type        = list(string)
}

variable "default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  type        = number
  default     = 300
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = 300
}

variable "health_check_type" {
  description = "Controls how health checking is done. Values are - EC2 and ELB"
  type        = string
}

variable "force_delete" {
  description = "Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling"
  type        = bool
  default     = false
}

variable "load_balancers" {
  description = "A list of elastic load balancer names to add to the autoscaling group names"
  type        = list(string)
  default     = []
}

variable "target_group_arns" {
  description = "A list of aws_alb_target_group ARNs, for use with Application Load Balancing"
  type        = list(string)
  default     = []
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default"
  type        = list(string)
  default     = ["Default"]
}

variable "suspended_processes" {
  description = "A list of processes to suspend for the AutoScaling Group. The allowed values are Launch, Terminate, HealthCheck, ReplaceUnhealthy, AZRebalance, AlarmNotification, ScheduledActions, AddToLoadBalancer. Note that if you suspend either the Launch or Terminate process types, it can prevent your autoscaling group from functioning properly."
  type        = list(string)
  default     = []
}

variable "tags_as_map" {
  description = "A map of tags and values in the same format as other resources accept. This will be converted into the non-standard format that the aws_autoscaling_group requires."
  type        = map(string)
  default     = {}
}

variable "metrics_granularity" {
  description = "The granularity to associate with the metrics to collect. The only valid value is 1Minute"
  type        = string
  default     = "1Minute"
}

variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances"
  type        = list(string)
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  type        = string
  default     = "10m"
}

variable "min_elb_capacity" {
  description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
  type        = number
  default     = 0
}

variable "wait_for_elb_capacity" {
  description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over min_elb_capacity behavior."
  type        = number
  default     = null
}

variable "protect_from_scale_in" {
  description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for termination during scale in events."
  type        = bool
  default     = false
}

variable "service_linked_role_arn" {
  description = "The ARN of the service-linked role that the ASG will use to call other AWS services."
  type        = string
  default     = ""
}

variable "max_instance_lifetime" {
  description = "The maximum amount of time, in seconds, that an instance can be in service, values must be either equal to 0 or between 604800 and 31536000 seconds."
  type        = number
  default     = 0
}

variable "enable_instance_refresh" {
  description = "Enable the instance refresh option of AWS Auto Scaling groups"
  type        = bool
  default     = false
}

variable "refresh_instance_warmup" {
  description = "(Optional) Number of seconds to allow for the instance to fully build and warm up before it is ready to use, omitting uses the default asg healthcheck grace period"
  type        = number
  default     = null
}

variable "refresh_min_healthy_percentage" {
  description = "(Optional) The amount of capacity in the Auto Scaling group that must remain healthy during an instance refresh to allow the operation to continue, as a percentage of the desired capacity of the Auto Scaling group. Defaults to 90"
  type        = number
  default     = 90
}

variable "refresh_triggers" {
  description = "(Optional) Set of additional property names that will trigger an Instance Refresh. A refresh will always be triggered by a change in any of launch_configuration, launch_template, or mixed_instances_policy."
  type        = set(string)
  default     = ["launch_template"]
}