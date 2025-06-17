locals {
  default_tags = merge(var.default_tags,
    {
      StackName          = var.stack_name
      Environment        = var.environment
      ManagedByTerraform = "true"

    }
  )

  metadata_http_tokens = var.ec2_enforce_imdsv2 ? "required" : "optional"

  security_s3_buckets      = data.vault_generic_secret.security_s3_buckets
  security_kms_keys        = data.vault_generic_secret.security_kms_keys
  security_ssm_bucket_name = var.ec2_enable_ssm_logging ? local.security_s3_buckets[0].data["session-manager-bucket-name"] : ""
  security_ssm_kms_key_arn = var.ec2_enable_ssm_logging ? local.security_kms_keys[0].data["session-manager-kms-key-arn"] : ""

  additional_ec2_ingress_cidr_blocks = var.ec2_ingress_cidr_blocks != null ? split(",", var.ec2_ingress_cidr_blocks) : []
}
