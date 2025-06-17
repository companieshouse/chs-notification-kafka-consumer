variable "zones" {
  description = "Map of Route53 zone parameters"
  type        = map(any)
  default     = {}
}

variable "ignore_vpc_changes" {
  description = "Boolean value that will allow users to ignore changes to VPC association"
  type        = bool
  default     = false
}