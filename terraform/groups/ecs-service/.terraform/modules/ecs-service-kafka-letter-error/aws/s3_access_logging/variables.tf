variable "aws_account" {
  description = "The account name, used in s3 logging bucket name.  E.g. development, staging or live."
  type        = string
}

variable "aws_region" {
  description = "The account region, used in s3 logging bucket name.  E.g. eu-west-2."
  type        = string
}

variable "source_s3_bucket_name" {
  description = "The source s3 bucket name"
  type        = string
}
