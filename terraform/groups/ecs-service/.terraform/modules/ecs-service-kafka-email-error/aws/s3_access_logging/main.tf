resource "aws_s3_bucket_logging" "access_logging" {
  bucket        = var.source_s3_bucket_name
  target_bucket = "${var.aws_account}-${var.aws_region}-s3-access-logs.ch.gov.uk"
  target_prefix = "${data.aws_caller_identity.current.id}/${var.aws_region}/${var.source_s3_bucket_name}/"
}
