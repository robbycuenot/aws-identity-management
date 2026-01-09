# Generated Terraform file for AWS IAM Identity Center
locals {
  groups_map = {
    # Local groups (resources)
    "GlobalAdministrators"  = aws_identitystore_group.GlobalAdministrators.group_id,
    "Developers"            = aws_identitystore_group.Developers.group_id,
    "SecurityAuditors"      = aws_identitystore_group.SecurityAuditors.group_id,
    "AWSControlTowerAdmins" = aws_identitystore_group.AWSControlTowerAdmins.group_id,
    # SCIM-provisioned groups (data sources)
    "Engineering" = data.aws_identitystore_group.Engineering.group_id
  }
}
