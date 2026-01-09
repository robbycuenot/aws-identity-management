# Generated Terraform file for AWS IAM Identity Center

resource "aws_identitystore_group" "GlobalAdministrators" {
  display_name      = "GlobalAdministrators"
  description       = "Global Administrator Group"
  identity_store_id = local.sso_instance_identity_store_id

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_identitystore_group" "Developers" {
  display_name      = "Developers"
  description       = "Development team members"
  identity_store_id = local.sso_instance_identity_store_id

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_identitystore_group" "SecurityAuditors" {
  display_name      = "SecurityAuditors"
  description       = "Read-only access to all accounts for security audits"
  identity_store_id = local.sso_instance_identity_store_id

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_identitystore_group" "AWSControlTowerAdmins" {
  display_name      = "AWSControlTowerAdmins"
  description       = "Admin rights to AWS Control Tower core and provisioned accounts"
  identity_store_id = local.sso_instance_identity_store_id

  lifecycle {
    prevent_destroy = true
  }
}
