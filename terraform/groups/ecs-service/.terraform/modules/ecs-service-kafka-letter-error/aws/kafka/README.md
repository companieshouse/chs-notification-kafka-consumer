# kafka

## Overview

Creates an Apache [Kafka](https://kafka.apache.org/) broker cluster

## Usage

```hcl
module "kafka" {
  source = "git@github.com:companieshouse/terraform-modules//aws/kafka?ref=feature/kafka"

  ami_owner_id                    = "12345"
  ami_version_pattern             = "\\d.\\d.\\d"
  dns_zone_name                   = local.dns_zone_name
  environment                     = "my-environment"
  instance_count                  = "3"
  instance_type                   = "t3.medium"
  kafka_broker_access             = {
    cidr_blocks: ["1.2.3.4/32"],
    list_ids: [],
  }
  kafka_zookeeper_connect_string  = zookeeper-server-1:2181,zookeeper-server-2:2181
  lvm_block_definitions           = [
    {
      aws_volume_size_gb: "10",
      filesystem_resize_tool: "xfs_growfs",
      lvm_logical_volume_device_node: "/dev/kafka/data",
      lvm_physical_volume_device_node: "/dev/example"
    }
  ]
  root_volume_size_gib            = "10"
  route53_available               = true
  service                         = "my-service"
  service_sub_type                = "kafka"
  ssh_access                      = {
    cidr_blocks: ["1.2.3.4/32"],
    list_ids: [],
  }
  ssh_keyname                     = "my-key"
  subnet_ids                      = ["subnet-example"]
  team                            = "my-team"
  vpc_id                          = "vpc-example"
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

| Name                           | Description                                                                                                                                                                                                                                                                                                                                             | Type           | Default                                  | Required |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ---------------------------------------- | -------- |
| ami_owner_id                   | The ID of the AMI owner                                                                                                                                                                                                                                                                                                                                 | `string`       | `-`                                      | yes      |
| ami_version_pattern            | The pattern with which to match kafka AMIs                                                                                                                                                                                                                                                                                                              | `string`       | `-`                                      | yes      |
| dns_zone_name                  | The name of the DNS zone we're using                                                                                                                                                                                                                                                                                                                    | `string`       | `-`                                      | yes      |
| environment                    | The environment name to be used when creating AWS resources                                                                                                                                                                                                                                                                                             | `string`       | `-`                                      | yes      |
| instance_count                 | The number of instances to provision                                                                                                                                                                                                                                                                                                                    | `number`       | `-`                                      | yes      |
| instance_type                  | The instance type to use                                                                                                                                                                                                                                                                                                                                | `string`       | `-`                                      | yes      |
| kafka_broker_access            | An object defining CIDR blocks and prefix list ids controlling access to kafka brokers                                                                                                                                                                                                                                                                  | `object`       | `{cidr_blocks: [],list_ids: [],}`        | no       |
| kafka_data_directory           | The location where Kafka will store it's data                                                                                                                                                                                                                                                                                                           | `string`       | `/data/kafka`                            | no       |
| kafka_home                     | The home directory of the kafka installation                                                                                                                                                                                                                                                                                                            | `string`       | `/opt/kafka`                             | no       |
| kafka_port                     | The port on which kafka listens for clients                                                                                                                                                                                                                                                                                                             | `number`       | `9092`                                   | no       |
| kafka_service_group            | The Linux group name for association with configuration files                                                                                                                                                                                                                                                                                           | `string`       | `kafka`                                  | no       |
| kafka_service_user             | The Linux username for ownership of configuration files                                                                                                                                                                                                                                                                                                 | `string`       | `kafka`                                  | no       |
| kafka_zookeeper_connect_string | The zookeeper connection string                                                                                                                                                                                                                                                                                                                         | `string`       | `-`                                      | yes      |
| lvm_block_definitions          | LVM block definitions                                                                                                                                                                                                                                                                                                                                   | `list(object)` | `-`                                      | yes      |
| root_volume_size_gib           | The size of the root volume in GiB; set this value to 0 to preserve the size specified in the AMI metadata. This value should not be smaller than the size specified in the AMI metadata and used by the root volume snapshot. The filesystem will be expanded automatically to use all available space for the volume and an XFS filesystem is assumed | `number`       | `-`                                      | yes      |
| route53_available              | A flag indicating whether Route53 is available                                                                                                                                                                                                                                                                                                          | `bool`         | `-`                                      | yes      |
| service                        | The service name to be used when creating AWS resources                                                                                                                                                                                                                                                                                                 | `string`       | `-`                                      | yes      |
| service_sub_type               | The service subtype name to be used when creating AWS resources                                                                                                                                                                                                                                                                                         | `string`       | `-`                                      | yes      |
| ssh_access                     | An object defining CIDR blocks and prefix list ids controlling access to SSH                                                                                                                                                                                                                                                                            | `object`       | `{cidr_blocks: [],list_ids: [],}`        | no       |
| ssh_keyname                    | The SSH keypair name to use for remote connectivity                                                                                                                                                                                                                                                                                                     | `string`       | `-`                                      | yes      |
| subnet_ids                     | The ids of the subnets into which we'll place instances                                                                                                                                                                                                                                                                                                 | `list(string)` | `-`                                      | yes      |
| team                           | The team responsible for administering the instance                                                                                                                                                                                                                                                                                                     | `string`       | `-`                                      | yes      |
| user_data_merge_strategy       | Merge strategy to apply to user-data sections for cloud-init                                                                                                                                                                                                                                                                                            | `string`       | `list(append)+dict(recurse_array)+str()` | no       |
| vpc_id                         | The VPC ID in which to create resources                                                                                                                                                                                                                                                                                                                 | `string`       | `-`                                      | yes      |

## Outputs

| Name         | Description                                                                                                                 |
| ------------ | --------------------------------------------------------------------------------------------------------------------------- |
| manual_steps | Any manual steps that may be required when automation isn't possible. For example DNS entries where Route53 isn't available |
