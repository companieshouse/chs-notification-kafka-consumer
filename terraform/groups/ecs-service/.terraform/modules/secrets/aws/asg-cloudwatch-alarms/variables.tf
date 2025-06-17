variable "autoscaling_group_name" {
  type        = string
  description = "ASG name to apply alarms to"
}

variable "prefix" {
  type        = string
  default     = "asg-alarms-"
  description = "Alarm Name Prefix"
}

# Instances in Service
variable "in_service_evaluation_periods" {
  type        = string
  default     = "5"
  description = "The number of data periods to evaluate before triggering an alert."
}

variable "in_service_statistic_period" {
  type        = string
  default     = "60"
  description = "The length of a data period in seconds to evaluate the resource."
}

variable "expected_instances_in_service" {
  type        = string
  default     = "1"
  description = "Total number of instances expected to be healthy and in service"
}

# Instances in Pending
variable "in_pending_evaluation_periods" {
  type        = string
  default     = "5"
  description = "The number of data periods to evaluate before triggering an alert."
}

variable "in_pending_statistic_period" {
  type        = string
  default     = "60"
  description = "The length of a data period in seconds to evaluate the resource."
}

# Instances in Standby
variable "in_standby_evaluation_periods" {
  type        = string
  default     = "5"
  description = "The number of data periods to evaluate before triggering an alert."
}

variable "in_standby_statistic_period" {
  type        = string
  default     = "60"
  description = "The length of a data period in seconds to evaluate the resource."
}

# Instances Terminating
variable "in_terminating_evaluation_periods" {
  type        = string
  default     = "5"
  description = "The number of data periods to evaluate before triggering an alert."
}

variable "in_terminating_statistic_period" {
  type        = string
  default     = "60"
  description = "The length of a data period in seconds to evaluate the resource."
}

# Total Instances
variable "total_instances_evaluation_periods" {
  type        = string
  default     = "5"
  description = "The number of data periods to evaluate before triggering an alert."
}

variable "total_instances_statistic_period" {
  type        = string
  default     = "60"
  description = "The length of a data period in seconds to evaluate the resource."
}

variable "total_instances_in_service" {
  type        = string
  default     = "1"
  description = "The length of a data period in seconds to evaluate the resource."
}

variable "actions_alarm" {
  type        = list
  default     = []
  description = "A list of actions to take when alarms are triggered. Will likely be an SNS topic for event distribution."
}

variable "actions_ok" {
  type        = list
  default     = []
  description = "A list of actions to take when alarms are cleared. Will likely be an SNS topic for event distribution."
}

variable "actions_insufficient" {
  type        = list
  default     = []
  description = "A list of actions to take when alarms are missing data. Will likely be an SNS topic for event distribution."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to apply to all taggable resources created by this module."
}
