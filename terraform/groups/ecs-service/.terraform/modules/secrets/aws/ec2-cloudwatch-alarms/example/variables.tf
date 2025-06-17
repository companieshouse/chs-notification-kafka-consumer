# Input variable definitions
variable "name" {
  type        = string
  description = "Tags used for the EC2 instance"
  default     = "terratest_example"
}