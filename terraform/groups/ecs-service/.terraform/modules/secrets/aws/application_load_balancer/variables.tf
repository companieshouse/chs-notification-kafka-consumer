#-------------------------------------------------------------------------------
# Common variables
#-------------------------------------------------------------------------------
variable "environment" {
  description = "The deployment environment name; combined with var.service to name created resources"
  type        = string
}

variable "service" {
  description = "The name of the service; combined with var.environment to name created resources"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC that the ALB resources will be created within"
  type        = string
}

#-------------------------------------------------------------------------------
# ALB variables
#-------------------------------------------------------------------------------
variable "enable_deletion_protection" {
  default     = true
  description = "Defines whether deletion protection is enabled (true) or not (false)"
  type        = bool
}

variable "idle_timeout" {
  default     = 60
  description = "The duration, in seconds, before idle connections are closed"
  type        = number
}

variable "internal" {
  default     = true
  description = "Defines whether the ALB will be created as an internal load balancer (true) or external (false)"
  type        = bool
}

variable "preserve_host_header" {
  default     = false
  description = "Defines whether host headers are preserved (true) or not (false)"
  type        = bool
}

variable "redirect_http_to_https" {
  default     = false
  description = "When true, a HTTP listener is created to redirect to the default HTTPS listener. When false, a HTTP listener is not created"
  type        = bool
}

variable "security_group_ids" {
  default     = []
  description = "A list of additional security group IDs to attach to the ALB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "A list of subnet IDs that the ALB will be configured to listen on"
  type        = list(string)
}

#-------------------------------------------------------------------------------
# Listener & Target group variables
#-------------------------------------------------------------------------------
variable "service_configuration" {
  default     = {}
  description = "A map of objects used to configure the desired load balancer listeners and target groups. The keys represent the services and the values are the respective listener and target group configuration items"
  type = map(object({
    listener_config = optional(object({
      port                = optional(number, 443)
      default_action_type = optional(string, "fixed-response")
      fixed_response = optional(object({
        content_type = optional(string, "text/plain")
        message_body = optional(string, "")
        status_code  = optional(number, 204)
      }), {})
    }), {}),
    target_group_config = optional(object({
      port        = optional(number, 80)
      protocol    = optional(string, "HTTP")
      target_type = optional(string, "instance")
      health_check = optional(object({
        healthy_threshold   = optional(number, 2)
        unhealthy_threshold = optional(number, 2)
        interval            = optional(number, 30)
        matcher             = optional(string, "200")
        path                = optional(string, "/health_check")
        port                = optional(number, 80)
        protocol            = optional(string, "HTTP")
        timeout             = optional(number, 30)
      }), {})
    }), {})
  }))
}

variable "ssl_policy" {
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  description = "The AWS SSL policy to apply to the HTTPS listener"
  type        = string
}

variable "ssl_certificate_arn" {
  description = "The ARN of the SSL certificate applied to the HTTPS listener"
  type        = string
}

#-------------------------------------------------------------------------------
# Security group specific variables
#-------------------------------------------------------------------------------
variable "create_security_group" {
  default     = false
  description = "When true, a security group will be created for the ALB. When false, var.security_group_ids list must be populated"
  type        = bool
}

variable "egress_cidrs" {
  default     = ["0.0.0.0/0"]
  description = "List of CIDR blocks that will have egress rules created"
  type        = list(string)
}

variable "ingress_cidrs" {
  default     = []
  description = "List of CIDR blocks that will have ingress rules created"
  type        = list(string)
}

variable "ingress_prefix_list_ids" {
  default     = []
  description = "List of Prefix List IDs that will have ingress rules created"
  type        = list(string)
}

#-------------------------------------------------------------------------------
# Route53 variables
#-------------------------------------------------------------------------------
variable "create_route53_aliases" {
  default     = false
  description = "Weather to create Route53 aliases pointing to the ALB"
  type        = bool
}
variable "route53_aliases" {
  default     = []
  description = "A list of aliases to point to the load balancer"
  type        = list(any)
}
variable "route53_zone_id" {
  default     = null
  description = "Route53 zone where the aliases will be created"
  type        = string
}
variable "route53_domain_name" {
  default     = null
  description = "Name of route53 zone where the aliases will be created"
  type        = string
}
