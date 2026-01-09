# Generated Terraform file for AWS IAM Identity Center

resource "aws_ssoadmin_permission_set" "AdministratorAccess" {
  instance_arn     = local.sso_instance_arn
  name             = "AdministratorAccess"
  description      = "Full administrator access with billing"
  session_duration = "PT1H"
}

resource "aws_ssoadmin_permission_set" "DeveloperAccess" {
  instance_arn     = local.sso_instance_arn
  name             = "DeveloperAccess"
  description      = "Power user access for developers"
  session_duration = "PT8H"
}

resource "aws_ssoadmin_permission_set" "ReadOnlyAccess" {
  instance_arn     = local.sso_instance_arn
  name             = "ReadOnlyAccess"
  description      = "Read-only access to all resources"
  session_duration = "PT12H"
}

resource "aws_ssoadmin_permission_set" "SecurityAudit" {
  instance_arn     = local.sso_instance_arn
  name             = "SecurityAudit"
  description      = "Security audit access"
  session_duration = "PT4H"
}

resource "aws_ssoadmin_permission_set" "TEAM-S3FullAccess" {
  instance_arn     = local.sso_instance_arn
  name             = "TEAM-S3FullAccess"
  description      = "Temporary elevated S3 access via TEAM"
  session_duration = "PT1H"
}
