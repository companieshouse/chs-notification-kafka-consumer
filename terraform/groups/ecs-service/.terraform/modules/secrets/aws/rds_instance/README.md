# rds_instance

A Terraform module to create an RDS instance with associated resources. These include:
- RDS instance
- RDS subnet group
- Option & parameter groups
- Security groups

The RDS instance will be deployed with GP3-based storage with the module auto-configuring the IOPS and storage throughput based on default G
P3 parameters for each RDS engine and allocated storage combination.

The following RDS engines are currently supported:
- mariadb
- mysql
- postgresql

## Multi-AZ Deployments

By default this role will create a standard, Single-AZ RDS instance. A Multi-AZ RDS instance can be deployed by defining the `multi_az` argument, documented below.

Use of the `multi_az` argument should be considered on a case-by-case basis due to RDS cost multiplication implications. Consider only using Multi-AZ deployments where RDS resilience is required, such as in a Live / Production environment.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | > 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | > 5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_option_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_option_group) | resource |
| [aws_db_parameter_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.ingress_cidrs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_prefix_lists](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_security_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_kms_key.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_rds_engine_version.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | Amount of storage allocated to the RDS instance in GiB | `number` | n/a | yes |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Determines whether modifications to the RDS instance configuration are applied immediately (true) or are scheduled for the next maintenance window (false) | `bool` | `false` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Defines whether auto\_minor\_version\_upgrade is enabled (true) or not (false) | `bool` | `false` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Retention period, in days, of automated RDS backups | `number` | n/a | yes |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | The window during which AWS can take automated backups. Cannot overlap with `maintenance_window` | `string` | n/a | yes |
| <a name="input_cloudwatch_logs_exports"></a> [cloudwatch\_logs\_exports](#input\_cloudwatch\_logs\_exports) | A list of engine logs to export to cloudwatch. If empty, the default logs will be exported | `list(string)` | `[]` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the database to create within the RDS | `string` | n/a | yes |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Defines whether deletion protection is enabled (true) or not (false) | `bool` | `true` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use | `string` | n/a | yes |
| <a name="input_engine_major_version"></a> [engine\_major\_version](#input\_engine\_major\_version) | Database engine major version | `string` | n/a | yes |
| <a name="input_engine_minor_version"></a> [engine\_minor\_version](#input\_engine\_minor\_version) | Database engine minor version | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to be used when creating AWS resources | `string` | n/a | yes |
| <a name="input_ingress_cidrs"></a> [ingress\_cidrs](#input\_ingress\_cidrs) | A list of CIDR blocks that will be permitted to connect to the RDS | `list(string)` | `[]` | no |
| <a name="input_ingress_prefix_list_ids"></a> [ingress\_prefix\_list\_ids](#input\_ingress\_prefix\_list\_ids) | A list of prefix list IDs that will be permitted to connect to the RDS | `list(string)` | `[]` | no |
| <a name="input_ingress_security_group_ids"></a> [ingress\_security\_group\_ids](#input\_ingress\_security\_group\_ids) | A list of security group IDs that will be permitted to connect to the RDS | `list(string)` | `[]` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Database instance class | `string` | n/a | yes |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The KMS Key ARN used to encrypt the RDS storage. If empty, the AWS default RDS key will be used | `string` | `""` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The window during which RDS maintenance can take place. Cannot overlap with `backup_window` | `string` | n/a | yes |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Defines whether the RDS should be configured for multi AZ operation (true) or not (false). Enabling Multi-AZ will provide resilience to the RDS deployment but will double the cost of the RDS resource. Not recommended for non-live environments. | `bool` | `false` | no |
| <a name="input_parameter_group_settings"></a> [parameter\_group\_settings](#input\_parameter\_group\_settings) | A list of objects defining custom RDS Parameter Group settings to be applied to the RDS instance | <pre>list(<br>    object({<br>      name         = string<br>      value        = string<br>      apply_method = string<br>    })<br>  )</pre> | `[]` | no |
| <a name="input_password"></a> [password](#input\_password) | The database password | `string` | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | The port on which the RDS will listen. If zero, the engine default will be used | `number` | `0` | no |
| <a name="input_service"></a> [service](#input\_service) | The service name to be used when creating AWS resources | `string` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | If the RDS is destroyed, defines whether taking a final snapshot should be skipped (true) or not (false) | `bool` | `false` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Determines whether the RDS storage will be encrypted (true) or not (false) | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs that will be used to create the RDS subnet group to deploy the RDS instance in to | `list(string)` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | The database username | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC that resources will be deployed in to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_arn"></a> [rds\_arn](#output\_rds\_arn) | n/a |
| <a name="output_rds_availability_zone"></a> [rds\_availability\_zone](#output\_rds\_availability\_zone) | n/a |
| <a name="output_rds_db_name"></a> [rds\_db\_name](#output\_rds\_db\_name) | n/a |
| <a name="output_rds_endpoint"></a> [rds\_endpoint](#output\_rds\_endpoint) | n/a |
| <a name="output_rds_engine"></a> [rds\_engine](#output\_rds\_engine) | n/a |
| <a name="output_rds_engine_version"></a> [rds\_engine\_version](#output\_rds\_engine\_version) | n/a |
| <a name="output_rds_identifier"></a> [rds\_identifier](#output\_rds\_identifier) | n/a |
| <a name="output_rds_security_group_id"></a> [rds\_security\_group\_id](#output\_rds\_security\_group\_id) | n/a |
| <a name="output_rds_security_group_name"></a> [rds\_security\_group\_name](#output\_rds\_security\_group\_name) | n/a |
<!-- END_TF_DOCS -->

## Examples

Deploying a basic MySQL 8.0.33 RDS instance:
```hcl
module "mysql_rds" {
  source = "git@github.com:companieshouse/terraform-modules//aws/rds_instance?ref=<tag>"

  environment             = var.environment
  service                 = var.service
  team                    = var.team

  vpc_id                  = "<vpc-id>"
  subnet_ids              = ["<subnet-id-1>", "<subnet-id-N..">]
  ingress_cidrs           = ["<cidr-1>", "<cidr-2>", "<cidr-N..>"]

  db_name                 = "my-mysql-db"
  username                = "<username>"
  password                = "<password>"
  allocated_storage       = 25
  apply_immediately       = true
  backup_retention_period = 7
  backup_window           = "03:00-06:00"
  deletion_protection     = false
  engine                  = "mysql"
  engine_major_version    = "8.0"
  engine_minor_version    = "33"
  instance_class          = db.t3a.small
  maintenance_window      = "Sat:00:00-Sat:03:00"
}
```

Deploying a PostgreSQL 13.10, Multi-AZ, RDS instance:
```hcl
module "mysql_rds" {
  source = "git@github.com:companieshouse/terraform-modules//aws/rds_instance?ref=<tag>"

  environment              = var.environment
  service                  = var.service
  team                     = var.team

  vpc_id                   = data.aws_vpc.vpc.id
  subnet_ids               = data.aws_subnets.deployment.ids
  ingress_cidrs            = local.ingress_cidrs
  ingress_prefix_list_ids  = local.ingress_prefix_list_ids

  db_name                  = "my-postgres-db"
  username                 = "<username>"
  password                 = "<password>"
  allocated_storage        = 400
  backup_retention_period  = 14
  backup_window            = "03:00-06:00"
  engine                   = "postgres"
  engine_major_version     = "13"
  engine_minor_version     = "10"
  instance_class           = db.t4g.large
  maintenance_window       = "Sun:00:00-Sun:03:00"
  multi_az                 = true
  parameter_group_settings = [
    {
      name         = "max_wal_size"
      value        = "4096"
      apply_method = "immediate"
    },
    {
      name         = "temp_buffers"
      value        = "2048"
      apply_method = "immediate"
    }
  ]
}
```
