<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_account_password_policy.password_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_users_to_change_password"></a> [allow\_users\_to\_change\_password](#input\_allow\_users\_to\_change\_password) | Whether a user is allowed to change their password | `bool` | `true` | no |
| <a name="input_hard_expiry"></a> [hard\_expiry](#input\_hard\_expiry) | Whether users are prevented from setting a new password after their password has expired (i.e. requires administrator reset) | `bool` | `false` | no |
| <a name="input_max_password_age"></a> [max\_password\_age](#input\_max\_password\_age) | The age in days before a password expires and must be changed at next login | `number` | `90` | no |
| <a name="input_minimum_password_length"></a> [minimum\_password\_length](#input\_minimum\_password\_length) | The minimum length required when setting a new password | `number` | `14` | no |
| <a name="input_password_reuse_prevention"></a> [password\_reuse\_prevention](#input\_password\_reuse\_prevention) | The number of previous passwords that cannot be reused | `number` | `24` | no |
| <a name="input_require_lowercase_characters"></a> [require\_lowercase\_characters](#input\_require\_lowercase\_characters) | Whether a lowercase letter is required when setting a new password | `bool` | `true` | no |
| <a name="input_require_numbers"></a> [require\_numbers](#input\_require\_numbers) | Whether a number is required when setting a new password | `bool` | `true` | no |
| <a name="input_require_symbols"></a> [require\_symbols](#input\_require\_symbols) | Whether a symbol (or non-alphanumeric character) is required when setting a new password.  Allowed symbols are ! @ # $ % ^ & * ( ) \_ + - = [ ] { } \| ' | `bool` | `true` | no |
| <a name="input_require_uppercase_characters"></a> [require\_uppercase\_characters](#input\_require\_uppercase\_characters) | Whether an uppercase letter is required when setting a new password | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->