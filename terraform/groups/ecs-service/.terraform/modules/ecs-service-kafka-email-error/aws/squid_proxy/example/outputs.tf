output "autoscaling_group_names" {
  value = module.squid_proxy.autoscaling_group_names
}

output "autoscaling_group_arns" {
  value = module.squid_proxy.autoscaling_group_names
}

output "sns_topic_arn" {
  value = module.squid_proxy.autoscaling_group_names
}

output "intra_route_table_ids" {
  value = module.vpc.intra_route_table_ids
}
