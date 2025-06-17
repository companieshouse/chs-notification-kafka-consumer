# application_load_balancer

A module to create a standardised Application Load Balancer with optional listeners, target groups and security group.

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.listeners](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_http_cidrs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_http_prefix](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_https_cidrs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_https_prefix](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_route53_aliases"></a> [create\_route53\_aliases](#input\_create\_route53\_aliases) | Weather to create Route53 aliases pointing to the ALB | `bool` | `false` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | When true, a security group will be created for the ALB. When false, var.security\_group\_ids list must be populated | `bool` | `false` | no |
| <a name="input_egress_cidrs"></a> [egress\_cidrs](#input\_egress\_cidrs) | List of CIDR blocks that will have egress rules created | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Defines whether deletion protection is enabled (true) or not (false) | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The deployment environment name; combined with var.service to name created resources | `string` | n/a | yes |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | The duration, in seconds, before idle connections are closed | `number` | `60` | no |
| <a name="input_ingress_cidrs"></a> [ingress\_cidrs](#input\_ingress\_cidrs) | List of CIDR blocks that will have ingress rules created | `list(string)` | `[]` | no |
| <a name="input_ingress_prefix_list_ids"></a> [ingress\_prefix\_list\_ids](#input\_ingress\_prefix\_list\_ids) | List of Prefix List IDs that will have ingress rules created | `list(string)` | `[]` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Defines whether the ALB will be created as an internal load balancer (true) or external (false) | `bool` | `true` | no |
| <a name="input_preserve_host_header"></a> [preserve\_host\_header](#input\_preserve\_host\_header) | Defines whether host headers are preserved (true) or not (false) | `bool` | `false` | no |
| <a name="input_redirect_http_to_https"></a> [redirect\_http\_to\_https](#input\_redirect\_http\_to\_https) | When true, a HTTP listener is created to redirect to the default HTTPS listener. When false, a HTTP listener is not created | `bool` | `false` | no |
| <a name="input_route53_aliases"></a> [route53\_aliases](#input\_route53\_aliases) | A list of aliases to point to the load balancer | `list` | `[]` | no |
| <a name="input_route53_domain"></a> [route53\_domain](#input\_route53\_domain) | DNS domain name the ALB | `string` | `null` | no |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 zone where the aliases will be created | `string` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | A list of additional security group IDs to attach to the ALB | `list(string)` | `[]` | no |
| <a name="input_service"></a> [service](#input\_service) | The name of the service; combined with var.environment to name created resources | `string` | n/a | yes |
| <a name="input_service_configuration"></a> [service\_configuration](#input\_service\_configuration) | A map of objects used to configure the desired load balancer listeners and target groups. The keys represent the services and the values are the respective listener and target group configuration items | <pre>map(object({<br>    listener_config = optional(object({<br>      port                = optional(number, 443)<br>      default_action_type = optional(string, "fixed-response")<br>      fixed_response = optional(object({<br>        content_type = optional(string, "text/plain")<br>        message_body = optional(string, "")<br>        status_code  = optional(number, 204)<br>      }), {})<br>    }), {}),<br>    target_group_config = optional(object({<br>      port         = optional(number, 80)<br>      protocol     = optional(string, "HTTP")<br>      target_type  = optional(string, "instance")<br>      health_check = optional(object({<br>        healthy_threshold   = optional(number, 2)<br>        unhealthy_threshold = optional(number, 2)<br>        interval            = optional(number, 30)<br>        matcher             = optional(string, "200")<br>        path                = optional(string, "/health_check")<br>        port                = optional(number, 80)<br>        protocol            = optional(string, "HTTP")<br>        timeout             = optional(number, 30)<br>      }), {})<br>    }), {})<br>  }))</pre> | `{}` | no |
| <a name="input_ssl_certificate_arn"></a> [ssl\_certificate\_arn](#input\_ssl\_certificate\_arn) | The ARN of the SSL certificate applied to the HTTPS listener | `string` | n/a | yes |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | The AWS SSL policy to apply to the HTTPS listener | `string` | `"ELBSecurityPolicy-TLS13-1-2-2021-06"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs that the ALB will be configured to listen on | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC that the ALB resources will be created within | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_load_balancer_arn"></a> [application\_load\_balancer\_arn](#output\_application\_load\_balancer\_arn) | n/a |
| <a name="output_application_load_balancer_dns_name"></a> [application\_load\_balancer\_dns\_name](#output\_application\_load\_balancer\_dns\_name) | n/a |
| <a name="output_application_load_balancer_listener_arns"></a> [application\_load\_balancer\_listener\_arns](#output\_application\_load\_balancer\_listener\_arns) | n/a |
| <a name="output_application_load_balancer_name"></a> [application\_load\_balancer\_name](#output\_application\_load\_balancer\_name) | n/a |
| <a name="output_application_load_balancer_zone_id"></a> [application\_load\_balancer\_zone\_id](#output\_application\_load\_balancer\_zone\_id) | n/a |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | n/a |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | n/a |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | n/a |
