data "aws_rds_engine_version" "available" {
  engine      = var.engine
  include_all = true
  version     = local.engine_version
}

data "aws_kms_key" "default" {
  count  = var.kms_key_id == "" ? 1 : 0

  key_id = "alias/aws/rds"
}
