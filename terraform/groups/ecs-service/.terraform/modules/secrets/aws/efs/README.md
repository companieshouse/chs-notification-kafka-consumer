# efs

Deploys an encrypted Elastic File System with supporting resources including mount points for use with services such as ECS or EC2.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_efs_access_point.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_file_system_policy.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system_policy) | resource |
| [aws_efs_mount_target.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_security_group.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.efs_cidrs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.efs_deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.efs_prefix_lists](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.efs_security_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_iam_policy_document.access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnet.deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_points"></a> [access\_points](#input\_access\_points) | A map whose keys are descriptive labels and whose values define the required EFS access points and settings. Each access point is an application-specific view into an EFS file system that applies an operating system user and group, and a file system path, to any file system request made through the access point | <pre>map(object({<br>    permissions    = string<br>    posix_user_gid = number<br>    posix_user_uid = number<br>    root_directory = string<br>  }))</pre> | <pre>{<br>  "root": {<br>    "permissions": "0755",<br>    "posix_user_gid": 1000,<br>    "posix_user_uid": 1000,<br>    "root_directory": "/"<br>  }<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the deployment environment; used for naming and tagging | `string` | n/a | yes |
| <a name="input_ingress_cidrs"></a> [ingress\_cidrs](#input\_ingress\_cidrs) | A list of CIDRs that will be permitted access to connect to the EFS mount points | `list(string)` | `[]` | no |
| <a name="input_ingress_from_deployment_subnets"></a> [ingress\_from\_deployment\_subnets](#input\_ingress\_from\_deployment\_subnets) | Defines whether the deployment subnet CIDR blocks are automatically permitted access to the mount point security group | `bool` | `true` | no |
| <a name="input_ingress_prefix_list_ids"></a> [ingress\_prefix\_list\_ids](#input\_ingress\_prefix\_list\_ids) | A list of prefix list IDs that will be permitted access to connect to the EFS mount points | `list(string)` | `[]` | no |
| <a name="input_ingress_security_group_ids"></a> [ingress\_security\_group\_ids](#input\_ingress\_security\_group\_ids) | A list of security group IDs that will be permitted access to connect to the EFS mount points | `list(string)` | `[]` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The KMS key ARN to use for filesystem encryption | `string` | n/a | yes |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | The filesystem performance mode. | `string` | `"generalPurpose"` | no |
| <a name="input_permit_client_root_access"></a> [permit\_client\_root\_access](#input\_permit\_client\_root\_access) | Must be enabled (true) to allow clients to perform root-user operations on the file system; operations are squashed when disabled (false) | `bool` | `false` | no |
| <a name="input_service"></a> [service](#input\_service) | The name of the service the resources are being deployed for; used for naming and tagging | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs in which the EFS resources will be created | `list(string)` | n/a | yes |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | The filesystem throughput mode. Elastic automatically scales throughput performance up or down to meet the needs of your workload activity; bursting is recommended for workloads that require throughput that scales with the amount of storage | `string` | `"elastic"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID that resources will be deployed in to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_efs_access_point_arns"></a> [efs\_access\_point\_arns](#output\_efs\_access\_point\_arns) | Returns the arns for the EFS access point resources |
| <a name="output_efs_access_point_ids"></a> [efs\_access\_point\_ids](#output\_efs\_access\_point\_ids) | Returns the ids for the EFS access point resources |
| <a name="output_efs_access_points"></a> [efs\_access\_points](#output\_efs\_access\_points) | Returns all attributes for the EFS access point resources |
| <a name="output_efs_filesystem_arn"></a> [efs\_filesystem\_arn](#output\_efs\_filesystem\_arn) | Returns the arn attribute of the EFS resource |
| <a name="output_efs_filesystem_dns_name"></a> [efs\_filesystem\_dns\_name](#output\_efs\_filesystem\_dns\_name) | Returns the dns\_name attribute of the EFS resource |
| <a name="output_efs_filesystem_id"></a> [efs\_filesystem\_id](#output\_efs\_filesystem\_id) | Returns the id attribute of the EFS resource |
| <a name="output_efs_mount_target_dns_names"></a> [efs\_mount\_target\_dns\_names](#output\_efs\_mount\_target\_dns\_names) | Returns the AZ-specific mount\_target\_dns\_names for the EFS mount target resources |
| <a name="output_efs_mount_target_ids"></a> [efs\_mount\_target\_ids](#output\_efs\_mount\_target\_ids) | Returns the ids for the EFS mount target resources |
| <a name="output_efs_mount_target_ip_addresses"></a> [efs\_mount\_target\_ip\_addresses](#output\_efs\_mount\_target\_ip\_addresses) | Returns the ip addresses for the EFS mount target resources |
| <a name="output_efs_mount_targets"></a> [efs\_mount\_targets](#output\_efs\_mount\_targets) | Returns all attributes for the EFS mount target resource |
| <a name="output_efs_security_group_id"></a> [efs\_security\_group\_id](#output\_efs\_security\_group\_id) | Returns the id of the mount target security group resource |
<!-- END_TF_DOCS -->

## Examples

Create an EFS deployment with a default access point that can be utilised on ECS
```hcl
module "efs" {
  source = "git@github.com:companieshouse/terraform-modules//aws/efs?ref=<version>"

  environment = var.environment
  service     = var.service

  vpc_id      = data.aws_vpc.vpc.id
  subnet_ids  = data.aws_subnets.subnets.ids
}
```

Create an EFS deployment with NFS mount targets and multiple access points for client access
```hcl
module "efs" {
  source = "git@github.com:companieshouse/terraform-modules//aws/efs?ref=<version>"

  environment = var.environment
  service     = var.service

  vpc_id      = data.aws_vpc.vpc.id
  subnet_ids  = data.aws_subnets.subnets.ids

  access_points = {
    data = {
      permissions    = "0750"
      posix_user_gid = 1000
      posix_user_uid = 1000
      root_directory = "/data"
    },
    images = {
      permissions    = "0755"
      posix_user_gid = 1000
      posix_user_uid = 1000
      root_directory = "/images"
    }
  }
}
```
