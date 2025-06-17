#-------------------------------------------------------------------------------
# Shared Variables
#-------------------------------------------------------------------------------
variable "environment" {
  description = "The name of the deployment environment; used for naming and tagging"
  type        = string
}

variable "service" {
  description = "The name of the service the resources are being deployed for; used for naming and tagging"
  type        = string
}

#-------------------------------------------------------------------------------
# EFS Variables
#-------------------------------------------------------------------------------
variable "access_points" {
  default     = {
    root = {
      permissions    = "0755"
      posix_user_gid = 1000
      posix_user_uid = 1000
      root_directory = "/"
    }
  }
  description = "A map whose keys are descriptive labels and whose values define the required EFS access points and settings. Each access point is an application-specific view into an EFS file system that applies an operating system user and group, and a file system path, to any file system request made through the access point"
  type        = map(object({
    permissions    = string
    posix_user_gid = number
    posix_user_uid = number
    root_directory = string
  }))
}

variable "ingress_cidrs" {
  default     = []
  description = "A list of CIDRs that will be permitted access to connect to the EFS mount points"
  type        = list(string)
}

variable "ingress_prefix_list_ids" {
  default     = []
  description = "A list of prefix list IDs that will be permitted access to connect to the EFS mount points"
  type        = list(string)
}

variable "ingress_security_group_ids" {
  default     = []
  description = "A list of security group IDs that will be permitted access to connect to the EFS mount points"
  type        = list(string)
}

variable "ingress_from_deployment_subnets" {
  default     = true
  description = "Defines whether the deployment subnet CIDR blocks are automatically permitted access to the mount point security group"
  type        = bool
}

variable "kms_key_arn" {
  description = "The KMS key ARN to use for filesystem encryption"
  type        = string
}

variable "performance_mode" {
  default     = "generalPurpose"
  description = "The filesystem performance mode."
  type        = string

  validation {
    condition     = contains(["generalPurpose", "maxIO"], var.performance_mode)
    error_message = "performance_mode must be one of [\"generalPurpose\", \"maxIO\"]"
  }
}

variable "permit_client_root_access" {
  default     = false
  description = "Must be enabled (true) to allow clients to perform root-user operations on the file system; operations are squashed when disabled (false)"
  type        = bool
}

variable "subnet_ids" {
  description = "A list of subnet IDs in which the EFS resources will be created"
  type        = list(string)
}

variable "throughput_mode" {
  default     = "elastic"
  description = "The filesystem throughput mode. Elastic automatically scales throughput performance up or down to meet the needs of your workload activity; bursting is recommended for workloads that require throughput that scales with the amount of storage"
  type        = string

  validation {
    condition     = contains(["bursting", "elastic", "provisioned"], var.throughput_mode)
    error_message = "throughput_mode must be one of [\"bursting\", \"elastic\", \"provisioned\"]"
  }
}

variable "vpc_id" {
  description = "The VPC ID that resources will be deployed in to"
  type        = string
}
