output "this_route53_zone_zone_ids" {
  description = "Zone ID of Route53 zone"
  value       = { for k, v in aws_route53_zone.this : k => v.zone_id if var.ignore_vpc_changes == false }
}

output "this_route53_zone_name_servers" {
  description = "Name servers of Route53 zone"
  value       = { for k, v in aws_route53_zone.this : k => v.name_servers if var.ignore_vpc_changes == false }
}

output "this_lifecycle_route53_zone_zone_ids" {
  description = "Zone ID of Route53 zone"
  value       = { for k, v in aws_route53_zone.this_lifecycle : k => v.zone_id if var.ignore_vpc_changes == true }
}

output "this_lifecycle_route53_zone_name_servers" {
  description = "Name servers of Route53 zone"
  value       = { for k, v in aws_route53_zone.this_lifecycle : k => v.name_servers if var.ignore_vpc_changes == true }
}