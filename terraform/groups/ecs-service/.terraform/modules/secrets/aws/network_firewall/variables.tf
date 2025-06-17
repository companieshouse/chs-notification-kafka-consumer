variable "name" {
  type = string
  description = "Unique name to identify all resources in this deployment."
}

variable "tags" {
  type = map(string)
  description = "Map of tags to apply to all taggable resources deployed by this module."
  default = {}
}

variable "vpc_id" {
  type = string
  description = "VPC id of the VPC to deploy the firewall device in."
  validation {
    condition     = length(var.vpc_id) == 12 || length(var.vpc_id) == 21 && substr(var.vpc_id, 0, 4) == "vpc-"
    error_message = "VPC ID not valid."
  }
}

variable "firewall_endpoint_subnets" {
  type = list(string)
  description = "List of Subnet ID's to deploy firewall endpoints into." 
  validation {
    condition = length([ for id in var.firewall_endpoint_subnets : true
        if length(id) == 15 || length(id) == 24 &&                    #Total length matches either old or new format length
        split("-", id)[0] == "subnet" &&                              #ID has subnet prefix
        can(regex("[0-9,a-f]{8}|[0-9,a-f]{17}", split("-", id)[1]))   #Suffix is either 8 or 17 of allowed characters 
      ]
    ) == length(var.firewall_endpoint_subnets)
    error_message = "Subnet ID's are not valid."
  }
}

variable "firewall_policy_change_protection" {
  type = bool
  description = "A boolean flag indicating whether it is possible to change the associated firewall policy."
  default = false
}

variable "subnet_change_protection" {
  type = bool
  description = "A boolean flag indicating whether it is possible to change the associated subnet(s)."
  default = false
}

variable "firewall_delete_protection" {
  type        = bool
  description = "A boolean flag indicating whether deletion protection is enabled."
  default     = false
}

variable "filewall_stateful_engine_evaluation_order" {
  type = string
  description = "Evaluation order for the stateful rule engine of the firewall policy. Valid options: DEFAULT_ACTION_ORDER, STRICT_ORDER. Default DEFAULT_ACTION_ORDER"
  default = "DEFAULT_ACTION_ORDER"
  validation {
    condition = contains(["DEFAULT_ACTION_ORDER","STRICT_ORDER"], var.filewall_stateful_engine_evaluation_order)
    error_message = "Invalid input for var.filewall_stateful_engine_evaluation_order, valid options: DEFAULT_ACTION_ORDER, STRICT_ORDER. Default DEFAULT_ACTION_ORDER."
  }
}

variable "stateless_default_actions" {
  type = string
  description = "Set of actions to take on a packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: aws:drop, aws:pass, or aws:forward_to_sfe."
  default = "aws:forward_to_sfe"
  validation {
    condition = contains(["aws:drop", "aws:pass", "aws:forward_to_sfe"], var.stateless_default_actions)
    error_message = "Invalid input for var.stateless_default_actions, valid options: aws:drop, aws:pass, or aws:forward_to_sfe."
  }
}

variable "stateless_fragment_default_actions" {
  type = string
  description = "Set of actions to take on a fragmented packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: aws:drop, aws:pass, or aws:forward_to_sfe."
  default = "aws:forward_to_sfe"
  validation {
    condition = contains(["aws:drop", "aws:pass", "aws:forward_to_sfe"], var.stateless_fragment_default_actions)
    error_message = "Invalid input for var.stateless_fragment_default_actions, valid options: aws:drop, aws:pass, or aws:forward_to_sfe."
  }
}

variable "stateful_default_actions" {
  type = set(string)
  description = "Set of actions to take on a packet if it does not match any stateful rules in the policy. This can only be specified if the policy has a stateful_engine_options block with a rule_order value of STRICT_ORDER. You can specify one of either or neither values of aws:drop_strict or aws:drop_established, as well as any combination of aws:alert_strict and aws:alert_established."
  default = ["aws:alert_strict", "aws:alert_established"]
  validation {
    condition = length(setintersection(["aws:drop_strict", "aws:drop_established", "aws:alert_strict", "aws:alert_established" ], var.stateful_default_actions)) >= 1
    error_message = "Invalid input for var.stateful_default_actions."
  }
}

############################################################
#  Variable configuration for firewall logs. Only a single desination can be enabled for each log type of flow or alerts.
############################################################
variable "firewall_flow_logs_bucket_name" {
  type = string
  description = "Name of the S3 bucket to store firewall flow logs in. The bucket policy must be updated to provide access to the 'delivery.logs.amazonaws.com' principle from the firewall account. Set value as null to disable firewall flow logging to S3."
  default = null
}

variable "firewall_alert_logs_bucket_name" {
  type = string
  description = "Name of the S3 bucket to store firewall alert logs in. The bucket policy must be updated to provide access to the 'delivery.logs.amazonaws.com' principle from the firewall account. Set value as null to disable firewall alert logging to S3."
  default = null
}

variable "enable_firewall_cloudwatch_flow_logs" {
  type = bool
  description = "True to enable logging of firewall flow logs to a log group created by this module."
  default = false
}

variable "enable_firewall_cloudwatch_alert_logs" {
  type = bool
  description = "True to enable logging of firewall alert logs to a log group created by this module."
  default = false
}

variable "cloudwatch_log_retention_days" {
  type = number
  description = "Number of days to retain cloudwatch firewall logs for (if enabled). "
  default = 180
  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, 0], var.cloudwatch_log_retention_days)
    error_message = "Invalid input for cloudwatch_log_retention_days, Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, 0."
  }
}

variable "cloudwatch_kms_key" {
  type = string
  description = "KMS key to use for encryption of Firewall Cloudwatch logs (if enabled). Null to disable log encryption."
  default = null
}

variable "s3_access_logs_prefix" {
  type = string
  description = "Key prefix for any Firewall logs configured to be stored in S3"
  default = ""
}


############################################################
#  Variable configuration for firewall rule groups. 
############################################################
variable "stateless_rule_groups" {
  type = map(string)
  description = "Map of stateless rule groups and their priority to be attached to the Network firewall policy in the format { \"1\": \"rule_group\" }, were the key is a unique rule group priority in the policy, and the value is the arn of the stateless rule group."
  default = {}
  validation {
    condition = length([ for priority in keys(var.stateless_rule_groups) : can(tonumber(priority)) ]) == length(keys(var.stateless_rule_groups))
    error_message = "Invalid inputs for variable \"stateless_rule_groups\"."
  }
}

variable "managed_rule_group_arns" {
  type = list(string)
  description = "List of managed rule group ARNs to attach to the firewall policy."
  default = []
  validation {
    condition = length([ for arn in var.managed_rule_group_arns : can(regex("arn:aws:network-firewall:.*:aws-managed:stateful-rulegroup/.*",arn)) ]) == length(var.managed_rule_group_arns)
    error_message = "Invalid inputs for variable \"managed_rule_group_arns\"."
  }
}

variable "domain_rule_groups" {
  type = map(string)
  description = "List of domain rule group ARNs to attach to the firewall policy."
  default = {}
  validation {
    condition = length([ for priority in keys(var.domain_rule_groups) : can(tonumber(priority)) ]) == length(keys(var.domain_rule_groups))
    error_message = "Invalid inputs for variable \"domain_rule_groups\"."
  }
}

variable "stateful_rule_groups" {
  type = map(string)
  description = "Map of stateless rule groups and their priority to be attached to the Network firewall policy in the format { \"1\": \"rule_group\" }, were the key is a unique rule group priority in the policy, and the value is the arn of the stateless rule group."
  default = {}
  validation {
    condition = length([ for priority in keys(var.stateful_rule_groups) : can(tonumber(priority)) ]) == length(keys(var.stateful_rule_groups))
    error_message = "Invalid inputs for variable \"stateful_rule_groups\"."
  }
}
