output "application_load_balancer_arn" {
  value = aws_lb.alb.arn
}

output "application_load_balancer_dns_name" {
  value = aws_lb.alb.dns_name
}

output "application_load_balancer_listener_arns" {
  value = var.service_configuration != {} ? {
    for listener in aws_lb_listener.listeners : listener.port => listener.arn
  } : {}
}

output "application_load_balancer_name" {
  value = aws_lb.alb.name
}

output "application_load_balancer_zone_id" {
  value = aws_lb.alb.zone_id
}

output "security_group_arn" {
  value = var.create_security_group ? aws_security_group.sg[0].arn : ""
}

output "security_group_id" {
  value = var.create_security_group ? aws_security_group.sg[0].id : ""
}

output "security_group_name" {
  value = var.create_security_group ? aws_security_group.sg[0].name : ""
}
