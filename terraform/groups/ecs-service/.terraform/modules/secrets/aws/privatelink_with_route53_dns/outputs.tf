output "endpoint" {
  value       = aws_vpc_endpoint.this
  description = "Complete output of Endpoint attributes"
}

output "route53" {
  value       = aws_route53_zone.this[0]
  description = "Complete output of Route53 zone attributes"
}

output "endpoint_dns" {
  value       = aws_route53_record.this[0]
  description = "Complete output of Route53 zone attributes"
}
