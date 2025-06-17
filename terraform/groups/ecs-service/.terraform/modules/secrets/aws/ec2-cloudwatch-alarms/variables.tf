# Input variable definitions
variable "name_prefix" {
  type        = string
  description = "A prefix to be used in the names for each alarm created, to indentify them easier via the Console."
}

variable "instance_id" {
  type        = string
  description = "The instance Id to use for the alarms in this module"
}

variable "cpuutilization_evaluation_periods" {
  type        = string
  description = "The number of evaluation period over which to use when triggering alarms"
  default     = "5"
}

variable "cpuutilization_statistics_period" {
  type        = string
  description = "The number of seconds make each statistics period"
  default     = "60"
}

variable "cpuutilization_threshold" {
  type        = string
  description = "The value against which the CPUUtilization metric is compared, in percent."
  default     = "65"
}

variable "status_evaluation_periods" {
  type        = string
  description = "The number of evaluation period over which to use when triggering alarms"
  default     = "3"
}

variable "status_statistics_period" {
  type        = string
  description = "The number of seconds make each statistics period"
  default     = "60"
}

variable "namespace" {
  type        = string
  description = "The namespace that the custom metrics are being sent to, this is set in the CW Agent configuration and if not defined the CWAgent is the default for the agent so is also the default here."
  default     = "CWAgent"
}

variable "enable_disk_alarms" {
  type        = bool
  description = "Should alarms be enabled for low disk space. Note: requires custom metrics to be enabled in the EC2 cloudwatch agent configuration"
  default     = false
}

variable "disk_devices" {
  type = list(object({
    instance_device_mount_path = string
    instance_device_location   = string
    instance_device_fstype     = string
  }))
  description = "A list of objects each containing the required information, this relates to the disks mounted on the OS that you want to monitor for free space. Note: requires custom metrics to be enabled in the EC2 cloudwatch agent configuration"
  default     = null
}

variable "disk_evaluation_periods" {
  type        = string
  description = "The number of evaluation period over which to use when triggering alarms"
  default     = "3"
}

variable "disk_statistics_period" {
  type        = string
  description = "The number of seconds make each statistics period"
  default     = "60"
}

variable "low_disk_threshold" {
  type        = string
  description = "The value against which the disk_used_percent metric is compared, in percent."
  default     = "70"
}

variable "enable_memory_alarms" {
  type        = bool
  description = "Should alarms be enabled for memory metrics. Note: requires custom metrics to be enabled in the EC2 cloudwatch agent configuration"
  default     = false
}

variable "memory_evaluation_periods" {
  type        = string
  description = "The number of evaluation period over which to use when triggering alarms"
  default     = "3"
}

variable "memory_statistics_period" {
  type        = string
  description = "The number of seconds make each statistics period"
  default     = "60"
}

variable "available_memory_threshold" {
  type        = string
  description = "The value against which the mem_available_percent metric is compared, in percent."
  default     = "10"
}

variable "used_memory_threshold" {
  type        = string
  description = "The value against which the mem_used_percent metric is compared, in percent."
  default     = "80"
}

variable "used_swap_memory_threshold" {
  type        = string
  description = "The value against which the swap_used_percent metric is compared, in percent."
  default     = "6-"
}

variable "alarm_actions" {
  type        = list
  description = "The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN)."
  default     = []
}

variable "ok_actions" {
  type        = list
  description = "The list of actions to when actions are cleared. Will likely be an sns topic for event dustribution"
  default     = []
}

variable "insufficient_data_actions" {
  type        = list
  description = "The list of actions to run when data is missing from a metric and therefore cannot alarm. Will likely be an sns topic for event dustribution"
  default     = []
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to apply to all taggable resources created by this module."
}