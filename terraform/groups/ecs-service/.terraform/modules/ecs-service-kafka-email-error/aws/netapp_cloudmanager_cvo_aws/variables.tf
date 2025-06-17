
variable "workspace_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of the Cloud Manager workspace where you want to deploy Cloud Volumes ONTAP. If not provided, Cloud Manager uses the first workspace."
}

variable "data_encryption_type" {
  type        = string
  default     = "AWS"
  description = "(Optional) The type of encryption to use for the working environment: ['AWS', 'NONE']. The default is 'AWS'."
}

variable "ebs_volume_size" {
  type        = number
  default     = 1
  description = "(Optional) EBS volume size for the first data aggregate. For GB, the unit can be: [100 or 500]. For TB, the unit can be: [1,2,4,8,16]. The default is '1'"
}

variable "ebs_volume_size_unit" {
  type        = string
  default     = "TB"
  description = "(Optional) ['GB' or 'TB']. The default is 'TB'."
}

variable "ebs_volume_type" {
  type        = string
  default     = "gp3"
  description = "(Optional) The EBS volume type for the first data aggregate ['gp3','gp2','io1','st1','sc1']. The default is 'gp2'."
}

variable "iops" {
  type        = number
  description = "(Optional) Provisioned IOPS. Needed only when 'provider_volume_type' is 'io1' or 'gp3'"
}

variable "throughput" {
  type        = number
  description = "(Optional) Required only when 'provider_volume_type' is 'gp3'."
}
variable "use_latest_version" {
  type        = bool
  default     = true
  description = "(Optional) Indicates whether to use the latest available ONTAP version. The default is 'true'."
}

variable "ontap_version" {
  type        = string
  default     = null
  description = "(Optional) The required ONTAP version. Ignored if 'use_latest_version' is set to true. The default is to use the latest version."
}

variable "instance_type" {
  type        = string
  default     = "m5.xlarge"
  description = "(Optional) The instance type to use, which depends on the license type: Explore:['m5.xlarge'], Standard:['m5.2xlarge','r5.xlarge'], Premium:['m5.4xlarge','r5.2xlarge','c4.8xlarge'], BYOL: all instance types defined for PayGo. For more supported instance types, refer to Cloud Volumes ONTAP Release Notes. The default is 'm5.2xlarge'."
}

variable "is_ha" {
  type        = bool
  default     = true
  description = "Enable HA mode for Netapp Cloudmanager CVO"
}

variable "license_type" {
  type        = string
  default     = "ha-cot-explore-paygo"
  description = "The type of license to use. For single node: ['cot-explore-paygo','cot-standard-paygo', 'cot-premium-paygo', 'cot-premium-byol']. For HA: ['ha-cot-explore-paygo','ha-cot-standard-paygo','ha-cot-premium-paygo','ha-cot-premium-byol']."
  validation {
    condition     = contains(["cot-explore-paygo", "cot-standard-paygo", "cot-premium-paygo", "cot-premium-byol", "ha-cot-explore-paygo", "ha-cot-standard-paygo", "ha-cot-premium-paygo", "ha-cot-premium-byol"], var.license_type)
    error_message = "Provided licence type is not valid. Should be one of ['cot-explore-paygo','cot-standard-paygo', 'cot-premium-paygo', 'cot-premium-byol'] for single node or ['ha-cot-explore-paygo','ha-cot-standard-paygo','ha-cot-premium-paygo','ha-cot-premium-byol'] for HA."
  }
}

variable "platform_serial_numbers" {
  type        = list(string)
  default     = [null, null]
  description = "For HA BYOL, the serial numbers for the two nodes. This can be left nulled if using paygo, and should contain a list of one or two entries for single node or HA deploys respectively."
}

variable "capacity_tier" {
  type        = string
  default     = "S3"
  description = "(Optional) Whether to enable data tiering for the first data aggregate: ['S3','NONE']. The default is 'S3'."
}

variable "tier_level" {
  type        = string
  default     = "normal"
  description = "(Optional) The tiering level when 'capacity_tier' is set to 'S3' ['normal','ia','ia-single','intelligent']. The default is 'normal'."
  validation {
    condition     = contains(["normal", "ia", "ia-single", "intelligent"], var.tier_level)
    error_message = "Provided tier level is not valid. Should be one of ['normal','ia','ia-single','intelligent']."
  }
}

variable "nss_account" {
  type        = string
  default     = null
  description = "(Optional) The NetApp Support Site account ID to use with this Cloud Volumes ONTAP system. If the license type is BYOL and an NSS account isn't provided, Cloud Manager tries to use the first existing NSS account."
}

variable "cloud_provider_account" {
  type        = string
  default     = null
  description = "(Optional) The cloud provider credentials id to use when deploying the Cloud Volumes ONTAP system. You can find the ID in Cloud Manager from the Settings > Credentials page. If not specified, Cloud Manager uses the instance profile of the Connector."
}

variable "svm_password" {
  type        = string
  description = "The admin password for Cloud Volumes ONTAP."
}

variable "connector_client_id" {
  type        = string
  description = "The client ID of the Cloud Manager Connector."
}

variable "connector_accountId" {
  type        = string
  default     = null
  description = "AWS Account Id where NetApp connector is deployed, leave null if deployed int he same account as this module"
}

variable "failover_mode" {
  type        = string
  default     = "FloatingIP"
  description = "The failover mode for the HA pair: ['PrivateIP', 'FloatingIP']. 'PrivateIP' is for a single availability zone and 'FloatingIP' is for multiple availability zones."
  validation {
    condition     = contains(["PrivateIP", "FloatingIP"], var.failover_mode)
    error_message = "Failover mode is not valid, should be one of ['PrivateIP', 'FloatingIP']."
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to build CVO resources."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of Subnet IDs to build CVO resources."
}

variable "mediator_key_pair_name" {
  type        = string
  default     = null
  description = "The key pair name for the mediator instance."
}

variable "cluster_floating_ips" {
  type        = list(string)
  default     = [null, null, null, null]
  description = "List of Floating IPs to use if HA mode is set to 'FloatingIP'. If provided, should be of length 4 and contain 4 IP addresses outside of the VPC range."
  validation {
    condition     = length(var.cluster_floating_ips) == 4
    error_message = "Invalid input for cluster_floating_ips, requires list with 4 entries."
  }
}

variable "mediator_assign_public_ip" {
  type        = bool
  default     = false
  description = "Assign a public IP to the mediator. Default is false to route via existing egress path."
}

variable "route_table_ids" {
  type        = list(string)
  default     = null
  description = "The list of route table IDs that will be updated when using HA failover_mode of FloatingIP."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "List of tags to apply to all resources."
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks to allow ingress traffic to CVO nodes from."
}

variable "ingress_security_group_ids" {
  type        = list(string)
  default     = []
  description = "List of security groups blocks to allow ingress traffic to CVO nodes from."
}

variable "egress_cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of CIDR blocks to allow egress traffic from CVO nodes to."
}

variable "name" {
  type        = string
  description = "Name for the resources table being created"
}

variable "short_name" {
  type        = string
  description = "Short name for the cvo deployment module being created (to be referenced by iam connector roles and policies)"
}

variable "managed_tag_key" {
  type        = string
  default     = "CloudManager-Managed"
  description = "Tag key to attach to all instances to indicate these are managed by Netapp Cloudmanager. Used to control termination permissions."
}
