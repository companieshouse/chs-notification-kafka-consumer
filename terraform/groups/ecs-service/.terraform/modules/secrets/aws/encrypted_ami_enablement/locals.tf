locals {
  kms_operations = [
    "CreateGrant",
    "Decrypt",
    "DescribeKey",
    "GenerateDataKey",
    "GenerateDataKeyWithoutPlaintext",
    "ReEncryptFrom"
  ]

  role_names_map = {
    for role in var.service_role_names : lower(role) => role
  }
}
