variable "region" {
  description = "AWS Region"
  type        = string
}

variable "availability_zones" {
  description = "List of AZs to manage using only the letters, not full AZ name e.g. (a, b, c)"
  type        = list
}