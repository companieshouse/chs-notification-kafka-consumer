# zookeeper

## Overview

Creates an Apache [Zookeeper](https://zookeeper.apache.org/) cluster

## Usage

```hcl
module "zookeeper" {
  source = "git@github.com:companieshouse/terraform-modules//aws/zookeeper"

  ami_owner_id            = "12345"
  ami_version_pattern     = "\\d.\\d.\\d"
  dns_zone_name           = local.dns_zone_name
  environment             = "my-environment"
  instance_count          = "3"
  instance_type           = "t3.small"
  lvm_block_definitions   = [
    {
      aws_volume_size_gb: "10",
      filesystem_resize_tool: "xfs_growfs",
      lvm_logical_volume_device_node: "/dev/zookeeper/data",
      lvm_physical_volume_device_node: "/dev/example"
    }
  ]
  root_volume_size_gib    = "10"
  route53_available       = true
  service                 = "my-service"
  ssh_access              = {
    cidr_blocks: ["1.2.3.4/32"],
    list_ids: [],
  }
  ssh_keyname             = "my-key"
  subnet_ids              = ["subnet-example"]
  team                    = "my-team"
  vpc_id                  = "vpc-example"
  zookeeper_client_access = {
    cidr_blocks: ["1.2.3.4/32"],
    list_ids: [],
  }
  zookeeper_peer_access = {
    cidr_blocks: ["1.2.3.4/32"],
    list_ids: [],
  }
}
```

## Requirements

| Name      | Version            |
| --------- | ------------------ |
| terraform | >= 0.13, < 0.14 |

## Providers

| Name | Version          |
| ---- | ---------------- |
| aws  | >= 3.0, < 4.0 |

## Inputs

| Name                               | Description                                                                                                                                                                                                                                                                                                                                             | Type           | Default                                  | Required |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ---------------------------------------- | -------- |
| ami_owner_id                       | The ID of the AMI owner                                                                                                                                                                                                                                                                                                                                 | `string`       | `-`                                      | yes      |
| ami_version_pattern                | The pattern with which to match zookeeper AMIs                                                                                                                                                                                                                                                                                                          | `string`       | `-`                                      | yes      |
| dns_zone_name                      | The name of the DNS zone we're using                                                                                                                                                                                                                                                                                                                    | `string`       | `-`                                      | yes      |
| environment                        | The environment name to be used when creating AWS resources                                                                                                                                                                                                                                                                                             | `string`       | `-`                                      | yes      |
| instance_count                     | The number of instances to provision                                                                                                                                                                                                                                                                                                                    | `number`       | `-`                                      | yes      |
| instance_type                      | The instance type to use                                                                                                                                                                                                                                                                                                                                | `string`       | `-`                                      | yes      |
| lvm_block_definitions              | LVM block definitions                                                                                                                                                                                                                                                                                                                                   | `list(object)` | `-`                                      | yes      |
| root_volume_size_gib               | The size of the root volume in GiB; set this value to 0 to preserve the size specified in the AMI metadata. This value should not be smaller than the size specified in the AMI metadata and used by the root volume snapshot. The filesystem will be expanded automatically to use all available space for the volume and an XFS filesystem is assumed | `number`       | `-`                                      | yes      |
| route53_available                  | A flag indicating whether Route53 is available                                                                                                                                                                                                                                                                                                          | `bool`         | `-`                                      | yes      |
| service                            | The service name to be used when creating AWS resources                                                                                                                                                                                                                                                                                                 | `string`       | `-`                                      | yes      |
| service_sub_type                   | The service subtype name to be used when creating AWS resources                                                                                                                                                                                                                                                                                         | `string`       | `-`                                      | yes      |
| ssh_access                         | An object defining CIDR blocks and prefix list ids controlling access to SSH                                                                                                                                                                                                                                                                            | `object`       | `{cidr_blocks: [],list_ids: [],}`        | no       |
| ssh_keyname                        | The SSH keypair name to use for remote connectivity                                                                                                                                                                                                                                                                                                     | `string`       | `-`                                      | yes      |
| subnet_ids                         | The ids of the subnets into which we'll place instances                                                                                                                                                                                                                                                                                                 | `list(string)` | `-`                                      | yes      |
| team                               | The team responsible for administering the instance                                                                                                                                                                                                                                                                                                     | `string`       | `-`                                      | yes      |
| user_data_merge_strategy           | Merge strategy to apply to user-data sections for cloud-init                                                                                                                                                                                                                                                                                            | `string`       | `list(append)+dict(recurse_array)+str()` | no       |
| vpc_id                             | The VPC ID in which to create resources                                                                                                                                                                                                                                                                                                                 | `string`       | `-`                                      | yes      |
| zookeeper_autopurge_interval_hours | The time interval in hours for which the purge task has to be triggered                                                                                                                                                                                                                                                                                 | `number`       | `1`                                      | no       |
| zookeeper_client_access            | An object defining CIDR blocks and prefix list ids controlling access for zookeeper clients                                                                                                                                                                                                                                                             | `object`       | `{cidr_blocks: [],list_ids: [],}`        | no       |
| zookeeper_client_port              | The port on which zookeeper listens for clients                                                                                                                                                                                                                                                                                                         | `number`       | `2181`                                   | no       |
| zookeeper_data_directory           | The location where ZooKeeper will store the in-memory database snapshots and, unless specified otherwise, the transaction log of updates to the database                                                                                                                                                                                                | `string`       | `/data/zookeeper`                        | no       |
| zookeeper_election_port            | The port on which zookeeper listens for leader election                                                                                                                                                                                                                                                                                                 | `number`       | `3888`                                   | no       |
| zookeeper_heap_mb                  | The heap memory in MB to assign                                                                                                                                                                                                                                                                                                                         | `number`       | `512`                                    | no       |
| zookeeper_home                     | The home directory of the zookeeper installation                                                                                                                                                                                                                                                                                                        | `string`       | `/opt/zookeeper`                         | no       |
| zookeeper_init_limit_ticks         | Amount of time, in ticks, to allow followers to connect and sync to a leader. Increased this value as needed, if the amount of data managed by ZooKeeper is large                                                                                                                                                                                       | `number`       | `10`                                     | no       |
| zookeeper_peer_access              | An object defining CIDR blocks and prefix list ids controlling access for zookeeper peers                                                                                                                                                                                                                                                               | `object`       | `{cidr_blocks: [],list_ids: [],}`        | no       |
| zookeeper_peer_port                | The port on which zookeeper listens for peers                                                                                                                                                                                                                                                                                                           | `number`       | `2888`                                   | no       |
| zookeeper_service_group            | The Linux group name for association with configuration files                                                                                                                                                                                                                                                                                           | `string`       | `zookeeper`                              | no       |
| zookeeper_service_user             | The Linux username for ownership of configuration files                                                                                                                                                                                                                                                                                                 | `string`       | `zookeeper`                              | no       |
| zookeeper_snap_count               | The number of transactions recorded in the transaction log before a snapshot can be taken (and the transaction log rolled) is determined by snapCount                                                                                                                                                                                                   | `number`       | `20000`                                  | no       |
| zookeeper_snapshot_retain_count    | The number of most recent snapshots and corresponding transaction logs to retain in the dataDir and dataLogDir directories respectively. Defaults to 3. Minimum value is 3                                                                                                                                                                              | `number`       | `3`                                      | no       |
| zookeeper_sync_limit_ticks         | Amount of time, in ticks, to allow followers to sync with ZooKeeper                                                                                                                                                                                                                                                                                     | `number`       | `5`                                      | no       |
| zookeeper_tick_time                | The length of a single tick, which is the basic time unit used by ZooKeeper, as measured in milliseconds                                                                                                                                                                                                                                                | `number`       | `2000`                                   | no       |

## Outputs

| Name         | Description                                                                                                                 |
| ------------ | --------------------------------------------------------------------------------------------------------------------------- |
| instance_ips | The IP addresses of the provisioned instances                                                                               |
| manual_steps | Any manual steps that may be required when automation isn't possible. For example DNS entries where Route53 isn't available |
