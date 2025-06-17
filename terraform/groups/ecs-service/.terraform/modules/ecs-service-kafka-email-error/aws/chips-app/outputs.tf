output "app_address_internal" {
  value = aws_route53_record.app.fqdn
}

output "admin_address_internal" {
  value = aws_route53_record.admin[*].fqdn
}

output "application_subnets" {
  value = data.aws_subnet.application
}
