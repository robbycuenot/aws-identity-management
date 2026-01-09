# Generated Terraform file for AWS IAM Identity Center
locals {
  permission_set_managed_policy_attachments_flattened = flatten([
    for permission_set, policies in local.permission_set_managed_policy_attachments_map : [
      for policy in policies : {
        permission_set = permission_set
        policy         = policy
      }
    ]
  ])
}
