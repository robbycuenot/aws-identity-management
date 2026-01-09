# Generated Terraform file for AWS IAM Identity Center
locals {
  permission_sets_map = {
    "AdministratorAccess" = aws_ssoadmin_permission_set.AdministratorAccess.arn,
    "DeveloperAccess"     = aws_ssoadmin_permission_set.DeveloperAccess.arn,
    "ReadOnlyAccess"      = aws_ssoadmin_permission_set.ReadOnlyAccess.arn,
    "SecurityAudit"       = aws_ssoadmin_permission_set.SecurityAudit.arn,
    "TEAM-S3FullAccess"   = aws_ssoadmin_permission_set.TEAM-S3FullAccess.arn
  }
}
