locals {

  admin_cidrs              = values(data.vault_generic_secret.internal_cidrs.data)
  chs_cidrs                = values(data.vault_generic_secret.chs_cidrs.data)
  client_cidrs             = values(data.vault_generic_secret.client_cidrs.data)
  application_subnet_cidrs = [for s in data.aws_subnet.application : s.cidr_block]
  test_cidrs               = var.test_access_enable ? jsondecode(data.vault_generic_secret.test_cidrs.data["cidrs"]) : []
  ec2_data                 = data.vault_generic_secret.ec2_data.data

  ssh_source_security_groups = length(var.ssh_access_security_group_patterns) > 0 ? [
    for group in data.aws_security_group.ssh_access_groups : {
      id   = group.id
      name = group.name
    }
  ] : []
  
  nlb_subnet_mapping_data  = var.create_nlb ? data.vault_generic_secret.nlb_subnet_mappings[0].data : {}
  nlb_subnet_mapping_list  = var.create_nlb ? [
    for id in data.aws_subnets.application.ids : {
      subnet_id            = id
      private_ipv4_address = local.nlb_subnet_mapping_data[id]
    }
  ] : []

  internal_fqdn = format("%s.%s.aws.internal", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  security_kms_keys_data = data.vault_generic_secret.security_kms_keys.data
  kms_keys_data          = data.vault_generic_secret.kms_keys.data
  logs_kms_key_id        = local.kms_keys_data["logs"]
  ssm_kms_key_id         = local.security_kms_keys_data["session-manager-kms-key-arn"]
  sns_kms_key_id         = local.kms_keys_data["sns"]
  account_ssm_key_arn    = local.kms_keys_data["ssm"]

  security_s3_data            = data.vault_generic_secret.security_s3_buckets.data
  session_manager_bucket_name = local.security_s3_data["session-manager-bucket-name"]
  elb_access_logs_bucket_name = local.security_s3_data["elb-access-logs-bucket-name"]
  elb_access_logs_prefix      = "elb-access-logs"

  #For each log map passed, add an extra kv for the log group name and append the NFS directory into the filepath where required
  log_directory_prefix = format("%s/%s", var.nfs_mount_destination_parent_dir, lookup(var.nfs_mounts["application_root"], "local_mount_point", ""))
  cloudwatch_logs = {
    for log, map in var.cloudwatch_logs :
    log => merge(map, {
      "log_group_name" = "${var.application}-${log}",
      "file_path"      = replace(map["file_path"], "NFSPATH", "${local.log_directory_prefix}/APPINSTANCENAME")
      }
    )
  }
  # Extract the log group names for easier iteration
  log_groups = compact([for log, map in local.cloudwatch_logs : lookup(map, "log_group_name", "")])

  default_tags = {
    Terraform       = "true"
    Application     = upper(var.application)
    ApplicationType = upper(var.application_type)
    Service         = "CHIPS"
    Region          = var.aws_region
    Account         = var.aws_account
  }

  userdata_ansible_inputs = {
    default_nfs_server_address = var.nfs_server
    mounts_parent_dir          = var.nfs_mount_destination_parent_dir
    mounts                     = var.nfs_mounts
    install_watcher_service    = false
    cw_log_files               = local.cloudwatch_logs
    cw_agent_user              = "root"
    cw_namespace               = var.cloudwatch_namespace
    cw_asg_level_metrics       = "true"
  }
}
