output "aws_fms_policies" {
  value       = [for policy in aws_fms_policy.waf_v2 : policy]
  description = "The Firewall Manager policies created by this module"
}
