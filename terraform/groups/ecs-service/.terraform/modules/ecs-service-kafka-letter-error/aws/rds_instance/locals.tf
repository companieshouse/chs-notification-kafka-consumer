locals {
  resource_prefix        = "${var.environment}-${var.service}"

  db_engine_defaults_map = {
    default_logs_exports = {
      mariadb  = ["audit", "error", "general", "slowquery"]
      mysql    = ["audit", "error", "general", "slowquery"]
      postgres = ["postgresql", "upgrade"]
    }
    default_port = {
      mariadb  = 3306
      mysql    = 3306
      postgres = 5432
    }
    default_storage = {
      threshold = {
        mariadb  = 400
        mysql    = 400
        postgres = 400
      },
      small = {
        iops = {
          mariadb  = null
          mysql    = null
          postgres = null
        },
        throughput = {
          mariadb  = null
          mysql    = null
          postgres = null
        }
      },
      large = {
        iops = {
          mariadb  = 12000
          mysql    = 12000
          postgres = 12000
        },
        throughput = {
          mariadb  = 500
          mysql    = 500
          postgres = 500
        }
      }
    }
  }

  enabled_cloudwatch_logs_exports = length(var.cloudwatch_logs_exports) == 0 ? lookup(local.db_engine_defaults_map.default_logs_exports, var.engine) : var.cloudwatch_logs_exports
  engine_version                  = "${var.engine_major_version}.${var.engine_minor_version}"
  port                            = var.port == 0 ? lookup(local.db_engine_defaults_map.default_port, var.engine) : var.port
  iops                            = var.allocated_storage < lookup(local.db_engine_defaults_map.default_storage.threshold, var.engine) ? lookup(local.db_engine_defaults_map.default_storage.small.iops, var.engine) : lookup(local.db_engine_defaults_map.default_storage.large.iops, var.engine)
  kms_key_id                      = var.kms_key_id == "" ? data.aws_kms_key.default[0].arn : var.kms_key_id
  rds_identifier                  = "${local.resource_prefix}-${var.engine}"
  storage_throughput              = var.allocated_storage < lookup(local.db_engine_defaults_map.default_storage.threshold, var.engine) ? lookup(local.db_engine_defaults_map.default_storage.small.throughput, var.engine) : lookup(local.db_engine_defaults_map.default_storage.large.throughput, var.engine)

  rds_availability_zones_tag      = var.multi_az ? "multi" : "single"

  default_tags = {
    Environment = lower(var.environment)
    Service     = lower(var.service)
  }
}
