# ------------------------------------------------------------------------------
# Vault Variables
# ------------------------------------------------------------------------------
# variable "vault_username" {
#   type        = string
#   description = "Username for connecting to Vault - usually supplied through TF_VARS"
# }

# variable "vault_password" {
#   type        = string
#   description = "Password for connecting to Vault - usually supplied through TF_VARS"
# }

# ------------------------------------------------------------------------------
# AWS Variables
# ------------------------------------------------------------------------------
variable "aws_region" {
  type        = string
  description = "The AWS region in which resources will be administered"
}

variable "aws_account" {
  type        = string
  description = "The name of the AWS Account in which resources will be administered"
}

# ------------------------------------------------------------------------------
# AWS Variables - Shorthand
# ------------------------------------------------------------------------------

variable "short_account" {
  type        = string
  description = "Short version of the name of the AWS Account in which resources will be administered"
}

variable "short_region" {
  type        = string
  description = "Short version of the name of the AWS region in which resources will be administered"
}

# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------

variable "application" {
  type        = string
  description = "The component name of the application"
}

variable "application_type" {
  type        = string
  default     = "chips"
  description = "The parent name of the application"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

# ------------------------------------------------------------------------------
# ASG Variables
# ------------------------------------------------------------------------------

variable "instance_size" {
  type        = string
  description = "The size of the ec2 instances to build"
}

variable "asg_min_size" {
  type        = number
  default     = 1
  description = "The min size of the ASG - always 1"
}

variable "asg_max_size" {
  type        = number
  default     = 1
  description = "The max size of the ASG - always 1"
}

variable "asg_desired_capacity" {
  type        = number
  default     = 1
  description = "The desired capacity of ASG - always 1"
}

variable "asg_count" {
  type        = number
  description = "The number of ASGs - typically 1 for dev and 2 for staging/live"
}

variable "ami_name" {
  type        = string
  default     = "docker-ami-*"
  description = "Name of the AMI to use in the Auto Scaling configuration"
}

variable "instance_root_volume_size" {
  type        = number
  default     = 40
  description = "Size of root volume attached to instances"
}

variable "instance_swap_volume_size" {
  type        = number
  default     = 5
  description = "Size of swap volume attached to instances"
}

variable "alb_deletion_protection" {
  type        = bool
  default     = false
  description = "Enable or disable deletion protection for instances"
}

variable "alb_idle_timeout" {
  type        = number
  default     = 60
  description = "The idle connection timeout in seconds"
}

variable "enable_instance_refresh" {
  type        = bool
  default     = true
  description = "Enable or disable instance refresh when the ASG is updated"
}

variable "enforce_imdsv2" {
  type        = bool
  default     = true
  description = "Whether to enforce use of IMDSv2 by setting http_tokens to required on the aws_launch_template"
}

variable "shutdown_schedule" {
  type        = string
  default     = null
  description = "Cron expression for the shutdown time - e.g. '00 20 * * 1-5' is 8pm Mon-Fri"
}

variable "startup_schedule" {
  type        = string
  default     = null
  description = "Cron expression for the startup time - e.g. '00 06 * * 1-5' is 6am Mon-Fri"
}

# ------------------------------------------------------------------------------
# ALB Variables
# ------------------------------------------------------------------------------

variable "application_port" {
  type        = number
  default     = 21000
  description = "Target group backend port for application"
}

variable "admin_port" {
  type        = number
  default     = 21001
  description = "Target group backend port for administration"
}

variable "application_health_check_path" {
  type        = string
  default     = "/chips/cff"
  description = "Target group health check path for application"
}

variable "admin_health_check_path" {
  type        = string
  default     = "/console"
  description = "Target group health check path for administration console"
}

variable "domain_name" {
  type        = string
  default     = "*.companieshouse.gov.uk"
  description = "Domain Name for ACM Certificate"
}

variable "create_app_target_group" {
  type        = bool
  default     = true
  description = "Enable or disable the creation of a target group for the chips app"
}

variable "create_nlb" {
  type        = bool
  default     = false
  description = "Enable or disable the creation of a nlb that fronts the alb to provide static ips"
}

variable "maximum_4xx_threshold" {
  type        = number
  default     = 2
  description = "Threshold for number of 4xx errors"
}

variable "maximum_5xx_threshold" {
  type        = number
  default     = 2
  description = "Threshold for number of 5xx errors"
}

variable "test_access_enable" {
  type        = bool
  description = "Controls whether access from the Test subnets is required (true) or not (false)"
  default     = false
}

variable "ssh_access_security_group_patterns" {
  type        = list(string)
  description = "List of source security group name patterns that will have SSH access"
  default     = ["sgr-chips-control-asg-001-*"]
}

# ------------------------------------------------------------------------------
# Configuration and NFS Mount Variables
# ------------------------------------------------------------------------------
# See Ansible role for full documentation on NFS arguements:
#      https://github.com/companieshouse/ansible-collections/tree/main/ch_collections/heritage_services/roles/nfs/files/nfs_mounts
variable "nfs_server" {
  type        = string
  description = "The name or IP of the environment specific NFS server"
  default     = null
}

variable "nfs_mount_destination_parent_dir" {
  type        = string
  description = "The parent folder that all NFS shares should be mounted inside on the EC2 instance"
  default     = "/mnt"
}

variable "nfs_mounts" {
  type        = any
  description = "A map of objects which contains mount details for each mount path required."
  # Example: 
  #   nfs_share_name = {                  # The name of the NFS Share from the NFS Server
  #     local_mount_point = "folder",     # The name of the local folder to mount to under the parent directory, if omitted the share name is used.
  #     mount_options = [                 # Traditional mount options as documented for any NFS Share mounts
  #       "rw",
  #       "wsize=8192"
  #     ]
  #   }
  # }
  #
}

variable "default_log_group_retention_in_days" {
  type        = number
  default     = 14
  description = "Total days to retain logs in CloudWatch log group if not specified for specific logs"
}

variable "cloudwatch_logs" {
  type        = map(any)
  description = "Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging"
  default     = {}
}

variable "cloudwatch_namespace" {
  type        = string
  default     = "CHIPS"
  description = "A custom namespace to define for CloudWatch custom metrics such as memory and disk"
}

variable "cloudwatch_memory_alarm_threshold" {
  type        = number
  default     = 95
  description = "The threshold for the ASG's alarm on the EC2 metric mem_used_percent"
}

variable "config_bucket_name" {
  type        = string
  description = "Bucket name the application will use to retrieve configuration files"
  default     = ""
}

variable "app_instance_name_override" {
  type        = string
  description = "An alternative value to set for the app-instance-name tag on the EC2 instances."
  default     = null
}

variable "config_base_path_override" {
  type        = string
  description = "An alternative value to set for the config-base-path tag on the EC2 instances. The value supplied is prefixed with the config_bucket_name var."
  default     = null
}

variable "additional_userdata_prefix" {
  type        = string
  description = "Additional userdata prefix, will be executed before all other userdata and server configuration via Ansible"
  default     = ""
}

variable "additional_userdata_suffix" {
  type        = string
  description = "Additional userdata suffix, will be executed after server configuration via Ansible"
  default     = ""
}

variable "additional_ingress_with_cidr_blocks" {
  type        = list(map(string))
  description = "Additional ingress rules that can be set from outside of this module"
  default     = []
}

variable "enable_sns_topic" {
  type        = bool
  description = "A boolean value to indicate whether to deploy SNS topic configuration for CloudWatch actions"
  default     = false
}
