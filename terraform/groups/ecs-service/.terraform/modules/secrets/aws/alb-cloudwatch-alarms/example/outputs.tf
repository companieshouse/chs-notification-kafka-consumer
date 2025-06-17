output "alarm_unhealthy_host_count" {
  value = module.alb_alarms.alarm_unhealthy_host_count
}

output "alarm_httpcode_target_4xx_count" {
  value = module.alb_alarms.alarm_httpcode_target_4xx_count
}

output "alarm_httpcode_lb_4xx_count" {
  value = module.alb_alarms.alarm_httpcode_lb_4xx_count
}

output "alarm_httpcode_target_5xx_count" {
  value = module.alb_alarms.alarm_httpcode_target_5xx_count
}

output "alarm_httpcode_lb_5xx_count" {
  value = module.alb_alarms.alarm_httpcode_lb_5xx_count
}

output "target_response_time_average" {
  value = module.alb_alarms.target_response_time_average
}

output "alarm_client_tls_neg_err_count" {
  value = module.alb_alarms.alarm_client_tls_neg_err_count
}
