output "debug" {
  description = "Additional output for debugging"
  value = var.debug ? local.debug : {}
}

output "instance_ips" {
  description = "The ips of the provisioned hosts"
  value       = values(aws_instance.zookeepers).*.private_ip
}

output "manual_steps" {
  description = "A map of any manual steps that need to be carried out"
  value       = local.manual_steps
}
