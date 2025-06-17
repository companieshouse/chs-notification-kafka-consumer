variable "alb_arn_suffix" {
  type        = string
  description = "ALB Id to apply alarms to"
}

variable "target_group_arn_suffixes" {
  type        = list
  default     = []
  description = "Target Group suffix(es) to apply alarms to"
}

variable "prefix" {
  type        = string
  default     = ""
  description = "Alarm Name Prefix"
}

variable "unhealthy_hosts_threshold" {
  type        = string
  default     = "2"
  description = "Maximum number of allowed unhealthy hosts before alarm is triggered."
}

variable "response_time_threshold" {
  type        = string
  default     = "50"
  description = "The average number of milliseconds that requests should complete within."
}

variable "tls_negotiation_threshold" {
  type        = number
  default     = 0
  description = "The number of client TLS negotiation errors before triggering an alert"
}

variable "evaluation_periods" {
  type        = string
  default     = "5"
  description = "The number of evaluation period over which to use when triggering alarms e.g. the check must trigger 3 times before an alarm is raised, this number is multipled by the statistic_period value 3x60s = 180s in total before alarm is raised"
}

variable "statistic_period" {
  type        = string
  default     = "60"
  description = "The number of seconds that make each statistic period."
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

variable "maximum_4xx_threshold" {
  type        = string
  default     = "0"
  description = "The maximum allowed 4xx errors before an alarm is triggered"
}

variable "maximum_5xx_threshold" {
  type        = string
  default     = "0"
  description = "The maximum allowed 5xx errors before an alarm is triggered"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to apply to all taggable resources created by this module."
}
