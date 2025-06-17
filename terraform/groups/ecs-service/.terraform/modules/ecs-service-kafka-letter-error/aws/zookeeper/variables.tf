variable "ami_owner_id" {
  description = "The ID of the AMI owner"
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

variable "lvm_block_definitions" {
  description = "LVM block definitions"
  type = list(object({
    aws_volume_size_gb: string,
    filesystem_resize_tool: string,
    lvm_logical_volume_device_node: string,
    lvm_physical_volume_device_node: string,
  }))
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

variable "zookeeper_autopurge_interval_hours" {
  default     = 1
  description = "The time interval in hours for which the purge task has to be triggered"
  type        = number
}

variable "zookeeper_client_access" {
  default = {
    cidr_blocks: [],
    list_ids: [],
  }
  description = "An object defining CIDR blocks and prefix list ids controlling access for zookeeper clients"
  type = object({
    cidr_blocks: list(string),
    list_ids: list(string),
  })
}

variable "zookeeper_client_port" {
  default     = 2181
  description = "The port on which zookeeper listens for clients"
  type        = number
}

variable "zookeeper_data_directory" {
  default     = "/data/zookeeper"
  description = "The location where ZooKeeper will store the in-memory database snapshots and, unless specified otherwise, the transaction log of updates to the database"
  type        = string
}

variable "zookeeper_election_port" {
  default     = 3888
  description = "The port on which zookeeper listens for leader election"
  type        = number
}

variable "zookeeper_heap_mb" {
  default     = 512
  description = "The heap memory in MB to assign"
  type        = number
}

variable "zookeeper_home" {
  default     = "/opt/zookeeper"
  description = "The home directory of the zookeeper installation"
  type        = string
}

variable "zookeeper_init_limit_ticks" {
  default     = 10
  description = "Amount of time, in ticks, to allow followers to connect and sync to a leader. Increased this value as needed, if the amount of data managed by ZooKeeper is large"
  type        = number
}

variable "zookeeper_peer_access" {
  default = {
    cidr_blocks: [],
    list_ids: [],
  }
  description = "An object defining CIDR blocks and prefix list ids controlling access for zookeeper peers"
  type = object({
    cidr_blocks: list(string),
    list_ids: list(string),
  })
}

variable "zookeeper_peer_port" {
  default     = 2888
  description = "The port on which zookeeper listens for peers"
  type        = number
}

variable "zookeeper_service_group" {
  default     = "zookeeper"
  description = "The Linux group name for association with configuration files"
  type        = string
}

variable "zookeeper_service_user" {
  default     = "zookeeper"
  description = "The Linux username for ownership of configuration files"
  type        = string
}

variable "zookeeper_snap_count" {
  default     = 20000
  description = "The number of transactions recorded in the transaction log before a snapshot can be taken (and the transaction log rolled) is determined by snapCount"
  type        = number
}

variable "zookeeper_snapshot_retain_count" {
  default     = 3
  description = "The number of most recent snapshots and corresponding transaction logs to retain in the dataDir and dataLogDir directories respectively. Defaults to 3. Minimum value is 3."
  type        = number
}

variable "zookeeper_sync_limit_ticks" {
  default     = 5
  description = "Amount of time, in ticks, to allow followers to sync with ZooKeeper"
  type        = number
}

variable "zookeeper_tick_time" {
  default     = 2000
  description = "The length of a single tick, which is the basic time unit used by ZooKeeper, as measured in milliseconds"
  type        = number
}
