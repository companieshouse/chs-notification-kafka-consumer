resource "aws_db_subnet_group" "rds" {
  name       = "${local.rds_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    local.default_tags,
    {
      Name = "${local.rds_identifier}-subnet-group"
    }
  )
}

resource "aws_db_parameter_group" "rds" {
  name        = "${local.rds_identifier}-parameter-group"
  family      = data.aws_rds_engine_version.available.parameter_group_family
  description = "Parameter group for ${local.rds_identifier}"

  dynamic "parameter" {
    for_each = var.parameter_group_settings
    content {
      name         = parameter.value["name"]
      value        = parameter.value["value"]
      apply_method = parameter.value["apply_method"]
    }
  }

  tags = merge(
    local.default_tags,
    {
      Name = "${local.rds_identifier}-parameter-group"
    }
  )
}

resource "aws_db_option_group" "rds" {
  name                     = "${local.rds_identifier}-option-group"
  option_group_description = "Option group for ${local.rds_identifier}"
  engine_name              = var.engine
  major_engine_version     = var.engine_major_version

  tags = merge(
    local.default_tags,
    {
      Name = "${local.rds_identifier}-option-group"
    }
  )
}

resource "aws_db_instance" "rds" {
  allocated_storage               = var.allocated_storage
  apply_immediately               = var.apply_immediately
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  backup_retention_period         = var.backup_retention_period
  backup_window                   = var.backup_window
  db_name                         = var.db_name
  db_subnet_group_name            = aws_db_subnet_group.rds.name
  deletion_protection             = var.deletion_protection
  enabled_cloudwatch_logs_exports = local.enabled_cloudwatch_logs_exports
  engine                          = var.engine
  engine_version                  = local.engine_version
  final_snapshot_identifier       = "${local.rds_identifier}-final-deletion-snapshot"
  identifier                      = local.rds_identifier
  instance_class                  = var.instance_class
  iops                            = local.iops
  kms_key_id                      = local.kms_key_id
  maintenance_window              = var.maintenance_window
  multi_az                        = var.multi_az
  username                        = var.username
  password                        = var.password
  option_group_name               = aws_db_option_group.rds.name
  parameter_group_name            = aws_db_parameter_group.rds.name
  port                            = local.port
  skip_final_snapshot             = var.skip_final_snapshot
  storage_encrypted               = var.storage_encrypted
  storage_throughput              = local.storage_throughput
  storage_type                    = "gp3"
  vpc_security_group_ids          = [aws_security_group.rds.id]

  tags = merge(
    local.default_tags,
    {
      Name              = local.rds_identifier
      AvailabilityZones = local.rds_availability_zones_tag
    }
  )
}
