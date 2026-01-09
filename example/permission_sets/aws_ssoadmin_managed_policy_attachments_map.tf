# Generated Terraform file for AWS IAM Identity Center
locals {
  permission_set_managed_policy_attachments_map = {
    "AdministratorAccess" = [
      "AdministratorAccess",
      "Billing"
    ],
    "DeveloperAccess" = [
      "PowerUserAccess"
    ],
    "ReadOnlyAccess" = [
      "ReadOnlyAccess"
    ],
    "SecurityAudit" = [
      "ViewOnlyAccess",
      "AWSSSOReadOnly"
    ],
    "TEAM-S3FullAccess" = [
      "AmazonS3FullAccess"
    ]
  }
}
