variable "aws_account" {
  description = "The name of the AWS Account in which resources will be administered"
  type        = string
}

variable "aws_region" {
  description = "The AWS region in which resources will be administered"
  type        = string
}

variable "backup_retentions_days" {
  description = "A set of retention periods in days"
  type        = set(string)
}

variable "completion_window_minutes" {
  description = "The amount of time in minutes AWS Backup attempts a backup before canceling the job and returning an error"
  type        = number
}

variable "cron_schedule_expression" {
  description = "Backup cron scheduler expression"
  type        = string
}

variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "repository" {
  description = "The provisioning repository"
  type        = string
}

variable "start_window_minutes" {
  description = "The amount of time in minutes before beginning a backup"
  type        = number
}

variable "team" {
  description = "The owning team"
  type        = string
}
