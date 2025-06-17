variable "waf_v2_policies" {
  type        = list(any)
  default     = []
  description = <<-DOC
    name:
      The friendly name of the AWS Firewall Manager Policy.
    delete_all_policy_resources:
      Whether to perform a clean-up process.
      Defaults to `true`.
    exclude_resource_tags:
      A boolean value, if `true` the tags that are specified in the `resource_tags` are not protected by this policy.
      If set to `false` and `resource_tags` are populated, resources that contain tags will be protected by this policy.
      Defaults to `false`.
    remediation_enabled:
      A boolean value, indicates if the policy should automatically applied to resources that already exist in the account.
      Defaults to `false`.
    resource_type_list:
      A list of resource types to protect. Conflicts with `resource_type`.
    resource_type:
      A resource type to protect. Conflicts with `resource_type_list`.
    resource_tags:
      A map of resource tags, that if present will filter protections on resources based on the `exclude_resource_tags`.
    exclude_account_ids:
      A list of AWS Organization member Accounts that you want to exclude from this AWS FMS Policy.
    include_account_ids:
      A list of AWS Organization member Accounts that you want to include for this AWS FMS Policy.
    policy_data:
      default_action:
        The action that you want AWS WAF to take.
        Possible values: `ALLOW`, `BLOCK` or `COUNT`.
      override_customer_web_acl_association:
        Wheter to override customer Web ACL association
      logging_configuration:
        The WAFv2 Web ACL logging configuration.
      pre_process_rule_groups:
        A list of pre-proccess rule groups.
      post_process_rule_groups:
        A list of post-proccess rule groups.
  DOC
}