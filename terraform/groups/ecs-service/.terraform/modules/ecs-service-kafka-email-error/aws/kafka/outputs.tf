output "brokers" {
  description = "A list of the Kafka broker connection strings for convenience"
  value       = formatlist("%s:${var.kafka_port}", values(local.instance_definitions).*.hostname)
}

output "debug" {
  description = "Additional output for debugging"
  value       = var.debug ? local.debug : {}
}

output "manual_steps" {
  description = "A map containing any manual steps that may need to be carried out. Typically DNS"
  value       = local.manual_steps
}
