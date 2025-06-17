
variable "config_s3_bucket_name" {
  type        = string
  description = "Name of the S3 bucket AWS Config will output to"
}

variable "config_s3_bucket_prefix" {
  type        = string
  default     = ""
  description = "An optional prefix to prepend to the path Config writes to S3 under"
}

variable "kms_keys" {
  type        = set(string)
  default     = []
  description = "List of KMS key identifiers to grant the AWS config role access to. E.g. for S3 bucket or SNS topic encryption."
}

variable "config_recorder_all_supported" {
  type        = bool
  default     = true
  description = "Specifies whether AWS Config records configuration changes for every supported type of regional resource (which includes any new type that will become supported in the future). Conflicts with resource_types"
}

variable "config_recorder_include_global_resource_types" {
  type        = bool
  default     = null
  description = "Specifies whether AWS Config includes all supported types of global resources with the resources that it records. Requires all_supported = true. Conflicts with resource_types"
}

variable "config_recorder_resource_types" {
  type        = list(string)
  default     = null
  description = "A list that specifies the types of AWS resources for which AWS Config records configuration changes (for example, AWS::EC2::Instance or AWS::CloudTrail::Trail). config_recorder_all_supported must be set to false"
}

variable "config_sns_topic_arn" {
  type        = string
  default     = null
  description = "The ARN of the SNS topic that AWS Config delivers notifications to."
}

variable "config_delivery_frequency" {
  type        = string
  default     = null
  description = "The frequency with which AWS Config recurringly delivers configuration snapshots. Valid inputs: ( One_Hour | Three_Hours | Six_Hours | Twelve_Hours | TwentyFour_Hours )"
}

variable "config_rules" {
  type        = any
  default     = {}
  description = "A map providing details on any AWS Config rules to create. See readme details for variable format examples."
}

variable "is_aggregator" {
  type        = bool
  default     = false
  description = "Boolean to toggle if this account is an AWS Config Aggregator. If true, aggregation_account_ids is required."
}

variable "is_recorder" {
  type        = bool
  default     = true
  description = "Boolean to toggle if this region/account has an AWS Config Recorder."
}

variable "create_delivery_channel" {
  type        = bool
  default     = true
  description = "Boolean to toggle creation of AWS Config delivery channel"
}

variable "aggregate_account_ids" {
  type        = list(string)
  default     = null
  description = "Account IDs of AWS accounts to aggregate AWS Config outputs from. Provided accounts must be pre-configured with `aws_config_aggregate_authorization` specifying this account ID."
}

variable "aggregator_account_id" {
  type        = string
  default     = null
  description = "Account ID to grant permissions to aggregate Config outputs from this account."
}

variable "name" {
  type        = string
  description = "A name to use as part of resource naming"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "config_aggregate_regions" {
  type        = list(string)
  description = "List of source regions being aggregated."
  default     = []
}

variable "config_aggregate_enable_all_regions" {
  type        = bool
  description = "If true, aggregate existing AWS Config regions and future regions."
  default     = true
}

variable "config_aggregate_account_ids" {
  type        = list(string)
  description = "List of 12-digit account IDs of the account(s) being aggregated."
  default     = []
}

variable "config_recorder_iam_role_arn" {
  type        = string
  description = "ARN of an AWS role for use by AWS Config Recorder, used to enable the same role to be used across multi-region deploys."
  default     = null
}

variable "config_recorder_configrole_policy_name" {
  type        = string
  description = "Name of the appropriate ConfigRole policy. Added to support deprecated policy names; default maintains legacy naming"
  default     = "AWSConfigRole"
}
