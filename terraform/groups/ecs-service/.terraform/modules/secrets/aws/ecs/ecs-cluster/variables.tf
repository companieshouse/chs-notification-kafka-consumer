//----------------------------------------------------------------------
// Standard Variables
//----------------------------------------------------------------------
variable "stack_name" {
  description = "The name of the infrastructure 'stack' this cluster is part of."
  type        = string
}
variable "environment" {
  description = "The name of the environment this cluster is part of e.g. live, staging, dev. etc."
  type        = string
}
variable "aws_profile" {
  type        = string
  description = "The AWS profile to use for deployment."
}
variable "name_prefix" {
  description = "The prefix to use when naming resources in this cluster. Usually a combination of environment and stack_name for concistency e.g. '{stack_name}-{environment}'."
  type        = string
}

variable "default_tags" {
  description = "A map of default tags to be added to the resources"
  type        = map(any)
  default     = {}
}

//----------------------------------------------------------------------
// Networking Variables
//----------------------------------------------------------------------
variable "vpc_id" {
  description = "ID of the VPC to deploy resources into."
  type        = string
}
variable "subnet_ids" {
  description = "Comma seperated list of subnet ids to deploy the cluster into."
  type        = string
}
variable "alb_subnet_patterns" {
  description = "List of subnet name patterns that will be allowed access to the application ports.  These should normally be the ALB subnets and the default is the CHS subnets in dev, staging and live."
  type        = list(string)
  default = [
    "development-mm-platform-applications-*",
    "development-mm-platform-public-*",
    "development-mm-platform-routing-*",
    "staging-ch-platform-applications-*",
    "staging-ch-platform-public-*",
    "staging-ch-platform-routing-*",
    "live-mm-platform-applications-*",
    "live-mm-platform-public-*",
    "live-mm-platform-routing-*"
  ]
}

//----------------------------------------------------------------------
// Auto Scaling Group Variables
//----------------------------------------------------------------------
variable "asg_max_instance_count" {
  description = "The maximum allowed number of instances in the autoscaling group for the cluster."
  type        = number
  default     = 3
}

variable "asg_min_instance_count" {
  description = "The minimum allowed number of instances in the autoscaling group for the cluster."
  type        = number
  default     = 1
}

variable "asg_desired_instance_count" {
  description = "The desired number of instances in the autoscaling group for the cluster. Must fall within the min/max instance count range."
  type        = number
  default     = 2
}

variable "scaledown_schedule" {
  description = "The schedule to use when scaling down the number of EC2 instances to zero."
  # Typically used to stop all instances in a cluster to save resource costs overnight.
  # E.g. a value of '00 20 * * 1-7' would be Mon-Sun 8pm.  An empty string indicates that no schedule should be created.

  type    = string
  default = ""
}

variable "scaleup_schedule" {
  description = "The schedule to use when scaling up the number of EC2 instances to their normal desired level."
  # Typically used to start all instances in a cluster after it has been shutdown overnight.
  # E.g. a value of '00 06 * * 1-7' would be Mon-Sun 6am.  An empty string indicates that no schedule should be created.

  type    = string
  default = ""
}

variable "enable_asg_autoscaling" {
  description = "Whether to enable auto-scaling of the ASG by creating a capacity provider for the ECS cluster."
  type        = bool
  default     = false
}

variable "maximum_scaling_step_size" {
  description = "The maximum number of Amazon EC2 instances that Amazon ECS will scale out at one time.  Total is limited by asg_max_instance_count too."
  type        = number
  default     = 150
}

variable "minimum_scaling_step_size" {
  description = "The minimum number of Amazon EC2 instances that Amazon ECS will scale out at one time."
  type        = number
  default     = 1
}

variable "target_capacity" {
  description = "The target capacity utilization as a percentage for the capacity provider."
  type        = number
  default     = 100
}

//----------------------------------------------------------------------
// EC2 Launch Configuration Variables
//----------------------------------------------------------------------
variable "ec2_key_pair_name" {
  description = "The ec2 key pair name for SSH access to ec2 instances in the clusters auto scaling group."
  type        = string
  default     = "" # Empty string implies no key pair should be used so no SSH access is available on the instances
}
variable "ec2_image_id" {
  description = "The machine image to use when launching EC2 instances."
  type        = string
  default     = "ami-01255d13f656c60b9" # ECS optimized Amazon2 Linux in London created 25/04/2024
}
variable "ec2_instance_type" {
  description = "The ec2 instance type for ec2 instances in the clusters auto scaling group."
  type        = string
  default     = "t3.micro"
}
variable "ec2_root_block_device" {
  description = "Customize details about the root block device of the instance, apart from encryption which is always enabled and uses a cluster specific KMS key."
  type        = map(string)
  default = {
    volume_type = "gp3"
  }
}
variable "ec2_enforce_imdsv2" {
  description = "Whether to enforce use of IMDSv2 by setting http_tokens to required on the aws_launch_template"
  type        = bool
  default     = true
}
variable "ec2_ingress_cidr_blocks" {
  description = "Comma separated list of additional ingress CIDR ranges to allow access to application ports."
  type        = string
  default     = null
}
variable "ec2_ingress_sg_id" {
  description = "The security groups from which to allow access to port 80."
  type        = list(string)
  default     = []
}
variable "ec2_enable_ssm_logging" {
  description = "Whether to add a policy to allow centralised logging to the security account for SSM sessions."
  type        = bool
  default     = true
}

//----------------------------------------------------------------------
// ECS Cluster Variables
//----------------------------------------------------------------------
variable "enable_container_insights" {
  description = "A boolean value indicating whether to enable Container Insights or not"
  type        = bool
  default     = false
}

//----------------------------------------------------------------------
// Cloudwatch alerting
//----------------------------------------------------------------------
variable "create_sns_notify_topic" {
  description = "Whether to create an SNS notify topic for this cluster, which can be used by alarms to trigger notifications."
  type        = bool
  default     = true
}
variable "create_sns_ooh_topic" {
  description = "Whether to create an SNS out of hours topic for this cluster, which can be used by alarms to trigger alerts."
  type        = bool
  default     = true
}
variable "notify_topic_slack_endpoint" {
  description = "The webhook URL of the Slack endpoint that will be automatically subscribed to the topic. If left blank, no subscription will be created."
  type        = string
  default     = ""
}
