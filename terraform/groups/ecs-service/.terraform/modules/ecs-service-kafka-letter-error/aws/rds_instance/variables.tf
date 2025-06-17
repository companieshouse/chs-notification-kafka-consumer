#-------------------------------------------------------------------------------
# General vars
#-------------------------------------------------------------------------------
variable "environment" {
  description = "The environment name to be used when creating AWS resources"
  type        = string
}

variable "service" {
  description = "The service name to be used when creating AWS resources"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC that resources will be deployed in to"
  type        = string
}

#-------------------------------------------------------------------------------
# RDS vars
#-------------------------------------------------------------------------------
variable "allocated_storage" {
  description = "Amount of storage allocated to the RDS instance in GiB"
  type        = number
}

variable "apply_immediately" {
  default     = false
  description = "Determines whether modifications to the RDS instance configuration are applied immediately (true) or are scheduled for the next maintenance window (false)"
  type        = bool
}

variable "auto_minor_version_upgrade" {
  default     = false
  description = "Defines whether auto_minor_version_upgrade is enabled (true) or not (false)"
  type        = bool
}

variable "backup_retention_period" {
  description = "Retention period, in days, of automated RDS backups"
  type        = number
}

variable "backup_window" {
  description = "The window during which AWS can take automated backups. Cannot overlap with `maintenance_window`"
  type        = string
}

variable "cloudwatch_logs_exports" {
  default     = []
  description = "A list of engine logs to export to cloudwatch. If empty, the default logs will be exported"
  type        = list(string)
}

variable "db_name" {
  description = "The name of the database to create within the RDS"
  type        = string
}

variable "deletion_protection" {
  default     = true
  description = "Defines whether deletion protection is enabled (true) or not (false)"
  type        = bool
}

variable "engine" {
  description = "The database engine to use"
  type        = string

  validation {
    condition     = contains(["postgres", "mariadb", "mysql"], var.engine)
    error_message = "var.engine must be one of [postgres, mariadb, mysql]"
  }
}

variable "engine_major_version" {
  description = "Database engine major version"
  type        = string
}

variable "engine_minor_version" {
  description = "Database engine minor version"
  type        = string
}

variable "instance_class" {
  description = "Database instance class"
  type        = string
}

variable "maintenance_window" {
  description = "The window during which RDS maintenance can take place. Cannot overlap with `backup_window`"
  type        = string
}

variable "multi_az" {
  default     = false
  description = "Defines whether the RDS should be configured for multi AZ operation (true) or not (false). Enabling Multi-AZ will provide resilience to the RDS deployment but will double the cost of the RDS resource. Not recommended for non-live environments."
  type        = bool
}

variable "ingress_cidrs" {
  default     = []
  description = "A list of CIDR blocks that will be permitted to connect to the RDS"
  type        = list(string)
}

variable "ingress_prefix_list_ids" {
  default     = []
  description = "A list of prefix list IDs that will be permitted to connect to the RDS"
  type        = list(string)
}

variable "ingress_security_group_ids" {
  default     = []
  description = "A list of security group IDs that will be permitted to connect to the RDS"
  type        = list(string)
}

variable "kms_key_id" {
  default     = ""
  description = "The KMS Key ARN used to encrypt the RDS storage. If empty, the AWS default RDS key will be used"
  type        = string
}

variable "parameter_group_settings" {
  default     = []
  description = "A list of objects defining custom RDS Parameter Group settings to be applied to the RDS instance"
  type        = list(
    object({
      name         = string
      value        = string
      apply_method = string
    })
  )
}

variable "port" {
  default     = 0
  description = "The port on which the RDS will listen. If zero, the engine default will be used"
  type        = number
}

variable "skip_final_snapshot" {
  default     = false
  description = "If the RDS is destroyed, defines whether taking a final snapshot should be skipped (true) or not (false)"
  type        = bool
}

variable "storage_encrypted" {
  default     = true
  description = "Determines whether the RDS storage will be encrypted (true) or not (false)"
  type        = bool
}

variable "subnet_ids" {
  description = "A list of subnet IDs that will be used to create the RDS subnet group to deploy the RDS instance in to"
  type        = list(string)
}

variable "password" {
  description = "The database password"
  type        = string
}

variable "username" {
  description = "The database username"
  type        = string
}
