locals {

  alarm_sns_topic_arn_email = var.alarm_actions_enabled && var.alarm_topic_name != "" ? [data.aws_sns_topic.alarms[0].arn] : []
  alarm_sns_topic_arn_ooh = var.alarm_actions_enabled && var.alarm_topic_name_ooh != "" ? [data.aws_sns_topic.alarms_ooh[0].arn] : []

  alert_log_group_name = var.alert_log_group_name == "" ? "/aws/rds/instance/${var.db_instance_id}/alert" : var.alert_log_group_name

  metric_namespace = "Oracle Errors/${var.db_instance_shortname}"

  default_metrics = {
    archiver = {
      name                        = "${var.archiver_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.archiver_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.archiver_comparison_operator
      datapoints_to_alarm         = var.archiver_datapoints_to_alarm
      evaluation_periods          = var.archiver_evaluation_periods
      period                      = var.archiver_period
      statistic                   = var.archiver_statistic
      threshold                   = var.archiver_threshold
      filter_pattern              = var.archiver_filter_pattern
      filter_metric_value         = var.archiver_filter_metric_value
      filter_metric_default_value = var.archiver_filter_metric_default_value
      sns_topic_arn_list          = var.archiver_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    bgprocess = {
      name                        = "${var.bgprocess_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.bgprocess_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.bgprocess_comparison_operator
      datapoints_to_alarm         = var.bgprocess_datapoints_to_alarm
      evaluation_periods          = var.bgprocess_evaluation_periods
      period                      = var.bgprocess_period
      statistic                   = var.bgprocess_statistic
      threshold                   = var.bgprocess_threshold
      filter_pattern              = var.bgprocess_filter_pattern
      filter_metric_value         = var.bgprocess_filter_metric_value
      filter_metric_default_value = var.bgprocess_filter_metric_default_value
      sns_topic_arn_list          = var.bgprocess_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    checkpoint = {
      name                        = "${var.checkpoint_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.checkpoint_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.checkpoint_comparison_operator
      datapoints_to_alarm         = var.checkpoint_datapoints_to_alarm
      evaluation_periods          = var.checkpoint_evaluation_periods
      period                      = var.checkpoint_period
      statistic                   = var.checkpoint_statistic
      threshold                   = var.checkpoint_threshold
      filter_pattern              = var.checkpoint_filter_pattern
      filter_metric_value         = var.checkpoint_filter_metric_value
      filter_metric_default_value = var.checkpoint_filter_metric_default_value
      sns_topic_arn_list          = var.checkpoint_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    controlfile = {
      name                        = "${var.controlfile_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.controlfile_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.controlfile_comparison_operator
      datapoints_to_alarm         = var.controlfile_datapoints_to_alarm
      evaluation_periods          = var.controlfile_evaluation_periods
      period                      = var.controlfile_period
      statistic                   = var.controlfile_statistic
      threshold                   = var.controlfile_threshold
      filter_pattern              = var.controlfile_filter_pattern
      filter_metric_value         = var.controlfile_filter_metric_value
      filter_metric_default_value = var.controlfile_filter_metric_default_value
      sns_topic_arn_list          = var.controlfile_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    coredump = {
      name                        = "${var.coredump_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.coredump_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.coredump_comparison_operator
      datapoints_to_alarm         = var.coredump_datapoints_to_alarm
      evaluation_periods          = var.coredump_evaluation_periods
      period                      = var.coredump_period
      statistic                   = var.coredump_statistic
      threshold                   = var.coredump_threshold
      filter_pattern              = var.coredump_filter_pattern
      filter_metric_value         = var.coredump_filter_metric_value
      filter_metric_default_value = var.coredump_filter_metric_default_value
      sns_topic_arn_list          = var.coredump_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    datablock = {
      name                        = "${var.datablock_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.datablock_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.datablock_comparison_operator
      datapoints_to_alarm         = var.datablock_datapoints_to_alarm
      evaluation_periods          = var.datablock_evaluation_periods
      period                      = var.datablock_period
      statistic                   = var.datablock_statistic
      threshold                   = var.datablock_threshold
      filter_pattern              = var.datablock_filter_pattern
      filter_metric_value         = var.datablock_filter_metric_value
      filter_metric_default_value = var.datablock_filter_metric_default_value
      sns_topic_arn_list          = var.datablock_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    datafile = {
      name                        = "${var.datafile_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.datafile_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.datafile_comparison_operator
      datapoints_to_alarm         = var.datafile_datapoints_to_alarm
      evaluation_periods          = var.datafile_evaluation_periods
      period                      = var.datafile_period
      statistic                   = var.datafile_statistic
      threshold                   = var.datafile_threshold
      filter_pattern              = var.datafile_filter_pattern
      filter_metric_value         = var.datafile_filter_metric_value
      filter_metric_default_value = var.datafile_filter_metric_default_value
      sns_topic_arn_list          = var.datafile_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    rollback = {
      name                        = "${var.rollback_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.rollback_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.rollback_comparison_operator
      datapoints_to_alarm         = var.rollback_datapoints_to_alarm
      evaluation_periods          = var.rollback_evaluation_periods
      period                      = var.rollback_period
      statistic                   = var.rollback_statistic
      threshold                   = var.rollback_threshold
      filter_pattern              = var.rollback_filter_pattern
      filter_metric_value         = var.rollback_filter_metric_value
      filter_metric_default_value = var.rollback_filter_metric_default_value
      sns_topic_arn_list          = var.rollback_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    backupfail = {
      name                        = "${var.backupfail_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.backupfail_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.backupfail_comparison_operator
      datapoints_to_alarm         = var.backupfail_datapoints_to_alarm
      evaluation_periods          = var.backupfail_evaluation_periods
      period                      = var.backupfail_period
      statistic                   = var.backupfail_statistic
      threshold                   = var.backupfail_threshold
      filter_pattern              = var.backupfail_filter_pattern
      filter_metric_value         = var.backupfail_filter_metric_value
      filter_metric_default_value = var.backupfail_filter_metric_default_value
      sns_topic_arn_list          = var.backupfail_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    ora00600 = {
      name                        = "${var.ora00600_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.ora00600_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.ora00600_comparison_operator
      datapoints_to_alarm         = var.ora00600_datapoints_to_alarm
      evaluation_periods          = var.ora00600_evaluation_periods
      period                      = var.ora00600_period
      statistic                   = var.ora00600_statistic
      threshold                   = var.ora00600_threshold
      filter_pattern              = var.ora00600_filter_pattern
      filter_metric_value         = var.ora00600_filter_metric_value
      filter_metric_default_value = var.ora00600_filter_metric_default_value
      sns_topic_arn_list          = var.ora00600_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    sharedmem = {
      name                        = "${var.sharedmem_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.sharedmem_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.sharedmem_comparison_operator
      datapoints_to_alarm         = var.sharedmem_datapoints_to_alarm
      evaluation_periods          = var.sharedmem_evaluation_periods
      period                      = var.sharedmem_period
      statistic                   = var.sharedmem_statistic
      threshold                   = var.sharedmem_threshold
      filter_pattern              = var.sharedmem_filter_pattern
      filter_metric_value         = var.sharedmem_filter_metric_value
      filter_metric_default_value = var.sharedmem_filter_metric_default_value
      sns_topic_arn_list          = var.sharedmem_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    redolog = {
      name                        = "${var.redolog_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.redolog_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.redolog_comparison_operator
      datapoints_to_alarm         = var.redolog_datapoints_to_alarm
      evaluation_periods          = var.redolog_evaluation_periods
      period                      = var.redolog_period
      statistic                   = var.redolog_statistic
      threshold                   = var.redolog_threshold
      filter_pattern              = var.redolog_filter_pattern
      filter_metric_value         = var.redolog_filter_metric_value
      filter_metric_default_value = var.redolog_filter_metric_default_value
      sns_topic_arn_list          = var.redolog_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    snapshot = {
      name                        = "${var.snapshot_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.snapshot_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.snapshot_comparison_operator
      datapoints_to_alarm         = var.snapshot_datapoints_to_alarm
      evaluation_periods          = var.snapshot_evaluation_periods
      period                      = var.snapshot_period
      statistic                   = var.snapshot_statistic
      threshold                   = var.snapshot_threshold
      filter_pattern              = var.snapshot_filter_pattern
      filter_metric_value         = var.snapshot_filter_metric_value
      filter_metric_default_value = var.snapshot_filter_metric_default_value
      sns_topic_arn_list          = var.snapshot_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    extend = {
      name                        = "${var.extend_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.extend_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.extend_comparison_operator
      datapoints_to_alarm         = var.extend_datapoints_to_alarm
      evaluation_periods          = var.extend_evaluation_periods
      period                      = var.extend_period
      statistic                   = var.extend_statistic
      threshold                   = var.extend_threshold
      filter_pattern              = var.extend_filter_pattern
      filter_metric_value         = var.extend_filter_metric_value
      filter_metric_default_value = var.extend_filter_metric_default_value
      sns_topic_arn_list          = var.extend_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    extendlob = {
      name                        = "${var.extendlob_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.extendlob_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.extendlob_comparison_operator
      datapoints_to_alarm         = var.extendlob_datapoints_to_alarm
      evaluation_periods          = var.extendlob_evaluation_periods
      period                      = var.extendlob_period
      statistic                   = var.extendlob_statistic
      threshold                   = var.extendlob_threshold
      filter_pattern              = var.extendlob_filter_pattern
      filter_metric_value         = var.extendlob_filter_metric_value
      filter_metric_default_value = var.extendlob_filter_metric_default_value
      sns_topic_arn_list          = var.extendlob_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    extendtable = {
      name                        = "${var.extendtable_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.extendtable_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.extendtable_comparison_operator
      datapoints_to_alarm         = var.extendtable_datapoints_to_alarm
      evaluation_periods          = var.extendtable_evaluation_periods
      period                      = var.extendtable_period
      statistic                   = var.extendtable_statistic
      threshold                   = var.extendtable_threshold
      filter_pattern              = var.extendtable_filter_pattern
      filter_metric_value         = var.extendtable_filter_metric_value
      filter_metric_default_value = var.extendtable_filter_metric_default_value
      sns_topic_arn_list          = var.extendtable_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    extendtemp = {
      name                        = "${var.extendtemp_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.extendtemp_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.extendtemp_comparison_operator
      datapoints_to_alarm         = var.extendtemp_datapoints_to_alarm
      evaluation_periods          = var.extendtemp_evaluation_periods
      period                      = var.extendtemp_period
      statistic                   = var.extendtemp_statistic
      threshold                   = var.extendtemp_threshold
      filter_pattern              = var.extendtemp_filter_pattern
      filter_metric_value         = var.extendtemp_filter_metric_value
      filter_metric_default_value = var.extendtemp_filter_metric_default_value
      sns_topic_arn_list          = var.extendtemp_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    },
    cantaddfiles = {
      name                        = "${var.cantaddfiles_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.cantaddfiles_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.cantaddfiles_comparison_operator
      datapoints_to_alarm         = var.cantaddfiles_datapoints_to_alarm
      evaluation_periods          = var.cantaddfiles_evaluation_periods
      period                      = var.cantaddfiles_period
      statistic                   = var.cantaddfiles_statistic
      threshold                   = var.cantaddfiles_threshold
      filter_pattern              = var.cantaddfiles_filter_pattern
      filter_metric_value         = var.cantaddfiles_filter_metric_value
      filter_metric_default_value = var.cantaddfiles_filter_metric_default_value
      sns_topic_arn_list          = var.cantaddfiles_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    }
  }

  optional_metric_orastreams = var.orastreams_alarm_enable ? {
    orastreams = {
      name                        = "${var.orastreams_name_prefix} on ${var.db_instance_shortname}"
      description                 = "${var.orastreams_description_prefix} on ${var.db_instance_shortname}"
      comparison_operator         = var.orastreams_comparison_operator
      datapoints_to_alarm         = var.orastreams_datapoints_to_alarm
      evaluation_periods          = var.orastreams_evaluation_periods
      period                      = var.orastreams_period
      statistic                   = var.orastreams_statistic
      threshold                   = var.orastreams_threshold
      filter_pattern              = var.orastreams_filter_pattern
      filter_metric_value         = var.orastreams_filter_metric_value
      filter_metric_default_value = var.orastreams_filter_metric_default_value
      sns_topic_arn_list          = var.orastreams_alarm_ooh ? concat(local.alarm_sns_topic_arn_email, local.alarm_sns_topic_arn_ooh) : local.alarm_sns_topic_arn_email
    }
  } : {}

  metric_data = merge(
    local.default_metrics,
    local.optional_metric_orastreams
  )
}
