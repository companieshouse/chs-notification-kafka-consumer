output "endpoint" {
  value = module.privatelink.endpoint
}

output "r53" {
  value = module.privatelink.route53
}

output "r53_record" {
  value = module.privatelink.endpoint_dns
}