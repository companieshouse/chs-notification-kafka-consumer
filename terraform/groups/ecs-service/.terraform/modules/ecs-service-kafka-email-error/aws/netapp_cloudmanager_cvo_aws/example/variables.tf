variable "name" {
  type    = string
  default = "netapp-cloudmanager-cvo-aws-test"
}

variable "cloudmanager_refresh_token" {
  type = string
}

variable "key_name" {
  type = string
}

variable "cluster_floating_ips" {
  type    = list(string)
  default = ["192.168.255.1", "192.168.255.2", "192.168.255.3", "192.168.255.4"]
}

variable "svm_password" {
  type = string
}
