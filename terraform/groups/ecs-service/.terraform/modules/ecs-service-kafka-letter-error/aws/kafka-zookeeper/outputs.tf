output "debug" {
  description = "Additional output for debugging"
  value = var.debug ? local.debug : {}
}

output "manual_steps" {
  description = "A map of any manual steps that need to be carried out"
  value       = local.manual_steps
}
