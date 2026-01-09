# Generated Terraform file for AWS IAM Identity Center
locals {
  group_memberships_map = {
    "GlobalAdministrators" = [
      "alice@example.com"
    ],
    "Developers" = [
      "alice@example.com",
      "bob@example.com",
      "charlie@example.com"
    ],
    "SecurityAuditors" = [
      "alice@example.com",
      "charlie@example.com"
    ],
    "AWSControlTowerAdmins" = [
      "alice@example.com"
    ]
  }
}
