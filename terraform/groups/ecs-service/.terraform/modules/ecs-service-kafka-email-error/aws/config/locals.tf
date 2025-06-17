locals {
  config_aggregate_regions = coalescelist(var.config_aggregate_regions, [data.aws_region.current.name])

  config_s3_bucket_path = format(
    "arn:aws:s3:::%s/%sAWSLogs/%s/Config/*",
    var.config_s3_bucket_name,
    var.config_s3_bucket_prefix != null ? "${var.config_s3_bucket_prefix}/" : "",
    data.aws_caller_identity.current.account_id,
  )

  tags = merge(var.tags, {})
}
