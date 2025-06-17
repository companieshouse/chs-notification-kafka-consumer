output "example_asg_ids" {
  value = module.asg.asg_ids
}

output "example_asg_names_and_ids" {
  value = module.asg.asg_names_and_ids
}

output "example_lookup" {
  value = lookup(module.asg.asg_names_and_ids, "asg1", "not found")
}