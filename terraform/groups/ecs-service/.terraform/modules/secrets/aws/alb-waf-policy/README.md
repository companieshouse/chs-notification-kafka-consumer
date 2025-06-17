# alb-waf-policy
 
## Overview

This module allows users to create WAF_V2 policies for AWS Firewall Manager.
The module allows policies to contain:

- Included AWS Accounts
- Excluded AWS Accounts
  - You can specify inclusions **OR** exclusions, but not both. If you specify an include_map, AWS Firewall Manager applies the policy to all accounts specified by the include_map, and does not evaluate any exclude_map specifications. If you do not specify an include_map, then Firewall Manager applies the policy to all accounts except for those specified by the exclude_map.

- exclude_resource_tags
  -  (Required, Forces new resource) A boolean value, if true the tags that are specified in the resource_tags are not protected by this policy. If set to false and resource_tags are populated, resources that contain tags will be protected by this policy.
- resource_tags 
  - A map of resource tags, that if present will filter protections on resources based on the exclude_resource_tags.

- delete_all_policy_resources
  - If true, the request will also perform a clean-up process. Defaults to true. More information can be found here AWS Firewall Manager delete policy
- remediation_enabled - 
  - A boolean value, indicates if the policy should automatically applied to resources that already exist in the account.

- resource_type
  - A resource type to protect. Conflicts with resource_type_list. See the FMS API Reference for more information about supported values.

- resource_type_list 
  - A list of resource types to protect. Conflicts with resource_type. See the FMS API Reference for more information about supported values.

Please note that the Terratest will fail when testing on an AWS account that does have a Firewall Manager enabled already e.g. via an AWS Organisation.

## Usage

```hcl

provider "aws" {}

data "aws_caller_identity" "current" {
}

module "firewall_manager_waf_policies" {
  source = "../../alb-waf-policy"

  name          = "waf-policy"
  resource_type = "AWS::ElasticLoadBalancingV2::LoadBalancer"
  include_accounts_orgunits = {
    account = [
      data.aws_caller_identity.current.account_id
  }

  waf_v2_policies = {
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
          { name : "SizeRestrictions_Body" }
        ],
        ruleGroupType : "ManagedRuleGroup",
        overrideAction : { "type" : "NONE" },
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
        overrideAction : { "type" : "NONE" },
        ruleGroupArn : null,
        sampledRequestsEnabled : null
      }
    ]
  }
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.9, < 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 0.3, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 0.3, < 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_fms_policy.waf_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fms_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_waf_v2_policies"></a> [waf\_v2\_policies](#input\_waf\_v2\_policies) | name:<br>  The friendly name of the AWS Firewall Manager Policy.<br>delete\_all\_policy\_resources:<br>  Whether to perform a clean-up process.<br>  Defaults to `true`.<br>exclude\_resource\_tags:<br>  A boolean value, if `true` the tags that are specified in the `resource_tags` are not protected by this policy.<br>  If set to `false` and `resource_tags` are populated, resources that contain tags will be protected by this policy.<br>  Defaults to `false`.<br>remediation\_enabled:<br>  A boolean value, indicates if the policy should automatically applied to resources that already exist in the account.<br>  Defaults to `false`.<br>resource\_type\_list:<br>  A list of resource types to protect. Conflicts with `resource_type`.<br>resource\_type:<br>  A resource type to protect. Conflicts with `resource_type_list`.<br>resource\_tags:<br>  A map of resource tags, that if present will filter protections on resources based on the `exclude_resource_tags`.<br>exclude\_account\_ids:<br>  A list of AWS Organization member Accounts that you want to exclude from this AWS FMS Policy.<br>include\_account\_ids:<br>  A list of AWS Organization member Accounts that you want to include for this AWS FMS Policy.<br>policy\_data:<br>  default\_action:<br>    The action that you want AWS WAF to take.<br>    Possible values: `ALLOW`, `BLOCK` or `COUNT`.<br>  override\_customer\_web\_acl\_association:<br>    Wheter to override customer Web ACL association<br>  logging\_configuration:<br>    The WAFv2 Web ACL logging configuration.<br>  pre\_process\_rule\_groups:<br>    A list of pre-proccess rule groups.<br>  post\_process\_rule\_groups:<br>    A list of post-proccess rule groups. | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_fms_policies"></a> [aws\_fms\_policies](#output\_aws\_fms\_policies) | The Firewall Manager policies created by this module |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/#install)
- [golang](https://golang.org/doc/install#install)
- [golint](https://github.com/golang/lint#installation)

### Configurations

- Configure pre-commit hooks
```sh
pre-commit install
```


- Configure golang deps for tests
```sh
> go get github.com/gruntwork-io/terratest/modules/terraform
> go get github.com/stretchr/testify/assert
```



### Tests

- Tests are available in `test` directory

- In the test directory, run the below command
```sh
go test
```



## Authors

This project is authored by below people

- Raja Tatapudi

> This project was generated by [generator-tf-module](https://github.com/sudokar/generator-tf-module)
