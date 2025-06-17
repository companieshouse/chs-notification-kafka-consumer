variable "name" {
  type        = string
  description = "Identifier portion of the name, will have identifier prefix and suffix based on resource type and identifiers: e.g. asg-{var.name}-001"
}

variable "instance_type" {
  type        = string
  default     = "t3.small"
  description = "Instance type for proxy instance autoscaling configuration"
}

variable "ami_id" {
  type        = string
  default     = null
  description = "AMI id for proxy instance autoscaling configuration"
}

variable "key_name" {
  type        = string
  default     = null
  description = "Existing SSH key for management of proxy instances"
}

variable "asg_health_check_grace_period" {
  type        = number
  default     = 300
  description = "Time (in seconds) after instance comes into service before checking health."
}

variable "proxy_http_ingress_cidrs" {
  type        = list(string)
  default     = null
  description = "List of CIDR ranges to allow ingress traffic to ports provided in var.proxy_http_ingress_ports from"
}

variable "proxy_http_ingress_ports" {
  type        = list(number)
  default     = [80, 443]
  description = "List of ports to allow ingress traffic to for CIDR ranges provided in var.proxy_http_ingress_cidrs"
}

variable "proxy_mgmt_ingress_cidrs" {
  type        = list(string)
  default     = null
  description = "List of CIDR ranges to allow ingress traffic to ports provided in var.proxy_mgmt_ingress_ports from"
}

variable "proxy_mgmt_ingress_ports" {
  type        = list(number)
  default     = [22]
  description = "List of ports to allow ingress traffic to for CIDR ranges provided in var.proxy_mgmt_ingress_cidrs"
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "VPC ID to create proxy infrastructure in"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnets to create proxy instances in. All subnets must be in the VPC provided in var.vpc_id and should be in separate availability zones."
}

variable "ingress_route_table_ids" {
  type        = list(string)
  description = "List of route table ID's (one per subnet) we will update to route via the correct proxy instance. Length should be equal to 'var.private_subnet_ids' and be in the same AZ order."
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to apply to all taggable resources created by this module"
  default     = {}
}

variable "sns_kms_key" {
  type        = string
  default     = "alias/aws/sns"
  description = "KMS key ID, ARN or Alias for encryption of the SNS queue. Default is AWS provided key, set to null to disable encryption"
}

variable "log_group_retention_in_days" {
  type        = number
  default     = 365
  description = "Time in days to retain logs for, defaults to 365"
}

variable "lambda_timeout" {
  type        = number
  default     = 30
  description = "Time in seconds the lambda has to execute."
}

variable "enable_ssm" {
  type        = bool
  default     = true
  description = "Boolean to toggle dependancies for SSM to be created, e.g. IAM permissions. Requires agent to be pre-configured on AMI."
}

variable "ssm_logs_bucket" {
  type        = string
  default     = null
  description = "AWS S3 bucket name for SSM logs, used to create IAM permissions."
}

variable "ssm_logs_kms_key" {
  type        = string
  default     = null
  description = "KMS key ID used for SSM logs encryption."
}

variable "ssm_session_kms_key" {
  type        = string
  default     = null
  description = "KMS key ID used for SSM session encryption."
}

variable "userdata_template_custom" {
  default     = null
  description = "A pre-templated userdata input (using templatefile) that can be supplied to the launch template for the squid EC2. When default Null used, the built in module userdata will be used."
}

variable "cloudwatch_logs_to_collect" {
  default     = null
  description = "A list of log files to allow the instance to send logs to via the instance profile.When default Null used, the built in module log group will be used."
}

variable "custom_iam_statements" {
  default     = null
  description = "A list of statement blocks to create in addition to the built in permissions for squid e.g. additional S3 bucket access."
}

variable "enable_failover" {
  default = false
  description = "Toggle for enabling instance failover actions"
  type = bool
}
