provider "aws" {}

data "aws_caller_identity" "current" {
}

module "waf_policy" {
  source = "git@github.com:companieshouse/terraform-modules//aws/alb-waf-policy?ref=feature/alb-waf-policy"

  waf_v2_policies = [
    {
      name          = "waf-policy"
      resource_type = "AWS::ElasticLoadBalancingV2::LoadBalancer"

      include_account_ids = [
        data.aws_caller_identity.current.account_id
      ]

      resource_tags = {
        "Application" = "XML"
        "Test"        = "Case"
      }

      policy_data = {
        default_action                        = "allow"
        override_customer_web_acl_association = false
        pre_process_rule_groups = [
          {
            managedRuleGroupIdentifier : {
              vendorName : "AWS"
              managedRuleGroupName : "AWSManagedRulesCommonRuleSet"
              version : null
            },
            excludeRules : [
              { name : "SizeRestrictions_Body" },
              { name : "EC2MetaDataSSRF_Cookie" },
              { name : "CrossSiteScripting_Body" }
            ],
            ruleGroupType : "ManagedRuleGroup",
            overrideAction : { "type" : "COUNT" },
            ruleGroupArn : null,
            sampledRequestsEnabled : null
          },
          {

            managedRuleGroupIdentifier : {
              vendorName : "AWS"
              managedRuleGroupName : "AWSManagedRulesAnonymousIpList"
              version : null
            },
            excludeRules : [],
            ruleGroupType : "ManagedRuleGroup",
            overrideAction : { "type" : "COUNT" },
            ruleGroupArn : null,
            sampledRequestsEnabled : null
          }
        ]
      }
    }
  ]
}
