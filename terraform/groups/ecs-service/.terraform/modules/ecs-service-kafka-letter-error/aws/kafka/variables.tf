variable "ami_owner_id" {
  description = "The ID of the AMI owner"
  type        = string
}

variable "aws_instance_metadata_url" {
  default     = "http://169.254.169.254"
  description = "The URL comprising protocol and link-local IP address for retrieving instance metadata"
  type        = string
}

variable "debug" {
  description = "A flag indicating whether to output additional debug level information"
  type        = bool
}

variable "default_ami_version_pattern" {
  description = "The default AMI version pattern to use when matching AMIs"
  type        = string
}

variable "default_instance_type" {
  description = "The default instance type"
  type        = string
}

variable "dns_server_ip" {
  description = "The IP address of the DNS server to use and update"
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone we're using"
  type        = string
}

variable "environment" {
  description = "The environment name to be used when creating AWS resources"
  type        = string
}

variable "instance_specifications" {
  description = "A map of specifications for the instances"
  type = map(map(map(string)))
}

variable "instance_template_path" {
  default     = null
  description = "The path for any instance specific templates"
  type        = string
}

variable "kafka_broker_access" {
  default = {
    cidr_blocks: [],
    list_ids: [],
  }
  description = "An object defining CIDR blocks and prefix list ids controlling access to kafka brokers"
  type = object({
    cidr_blocks: list(string),
    list_ids: list(string),
  })
}

variable "kafka_data_directory" {
  default     = "/data/kafka"
  description = "The location where Kafka will store it's data"
  type        = string
}

variable "kafka_home" {
  default     = "/opt/kafka"
  description = "The home directory of the kafka installation"
  type        = string
}

variable "kafka_min_insync_replicas" {
  default     = 2
  description = "The value for the min.insync.replicas Kafka property. See https://kafka.apache.org/31/documentation.html#brokerconfigs_min.insync.replicas"
  type        = number
}

variable "kafka_offsets_topic_replication_factor" {
  default     = 3
  description = "The value for the offsets.topic.replication.factor Kafka property. See https://kafka.apache.org/31/documentation.html#brokerconfigs_offsets.topic.replication.factor"
  type        = number
}

variable "kafka_port" {
  default     = 9092
  description = "The port on which kafka listens for clients"
  type        = number
}

variable "kafka_service_group" {
  default     = "kafka"
  description = "The Linux group name for association with configuration files"
  type        = string
}

variable "kafka_service_user" {
  default     = "kafka"
  description = "The Linux username for ownership of configuration files"
  type        = string
}

variable "kafka_zookeeper_connect_string" {
  description = "The zookeeper connection string"
  type        = string
}

variable "lvm_block_definitions" {
  description = "LVM block definitions"
  type = list(object({
    aws_volume_size_gb: string,
    filesystem_resize_tool: string,
    lvm_logical_volume_device_node: string,
    lvm_physical_volume_device_node: string,
  }))
}

variable "ns_update_key_content" {
  description = "The content of the key used for nameserver updates"
  type        = string
}

variable "ns_update_key_path" {
  default     = "/root"
  description = "The path at which to store the key used for nameserver updates"
  type        = string
}

variable "prometheus_access" {
  default = {
    cidr_blocks: [],
    list_ids: [],
  }
  description = "An object defining CIDR blocks and prefix list ids controlling access to Prometheus"
  type = object({
    cidr_blocks: list(string),
    list_ids: list(string),
  })
}

variable "root_volume_size_gib" {
  description = "The size of the root volume in GiB; set this value to 0 to preserve the size specified in the AMI metadata. This value should not be smaller than the size specified in the AMI metadata and used by the root volume snapshot. The filesystem will be expanded automatically to use all available space for the volume and an XFS filesystem is assumed"
  type        = number
}

variable "route53_available" {
  description = "A flag indicating whether Route53 is available"
  type        = bool
}

variable "service" {
  description = "The service name to be used when creating AWS resources"
  type        = string
}

variable "service_sub_type" {
  description = "The service subtype name to be used when creating AWS resources"
  type        = string
}

variable "ssh_access" {
  default = {
    cidr_blocks: [],
    list_ids: [],
  }
  description = "An object defining CIDR blocks and prefix list ids controlling access to SSH"
  type = object({
    cidr_blocks: list(string),
    list_ids: list(string),
  })
}

variable "ssh_keyname" {
  description = "The SSH keypair name to use for remote connectivity"
  type        = string
}

variable "subnets" {
  description = "A map of subnets keyed by availability zone"
  type = map
}

variable "team" {
  description = "The team responsible for administering the instance"
  type        = string
}

variable "user_data_merge_strategy" {
  default     = "list(append)+dict(recurse_array)+str()"
  description = "Merge strategy to apply to user-data sections for cloud-init"
}

variable "vpc_id" {
  description = "The VPC ID in which to create resources"
  type        = string
}
