variable "name" {
  type    = string
  default = "squid_proxy_example"
}

variable "ami_id" {
  type    = string
  default = null
}

variable "key_pair_name" {
  type    = string
  default = null
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}
