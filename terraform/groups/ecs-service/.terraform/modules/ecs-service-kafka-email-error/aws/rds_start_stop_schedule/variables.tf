variable "rds_instance_id" {
  type        = string
  description = "The full Instance Id or Name of the RDS instance"
  default     = ""
}

variable "rds_schedule_enable" {
  type        = bool
  description = "Defines whether the schedules are active (true) or not (false)"
  default     = true
}

variable "rds_start_schedule" {
  type        = string
  description = "The schedule expression string that defines when the RDS instance will be started"
  default     = ""
}

variable "rds_stop_schedule" {
  type        = string
  description = "The schedule expression string that defines when the RDS instance will be stopped"
  default     = ""
}
