# Generated Terraform file for AWS IAM Identity Center

# Local user created by AWS Control Tower Account Factory
resource "aws_identitystore_user" "aws_production_example_com" {
  identity_store_id = local.sso_instance_identity_store_id
  user_name         = "aws+production@example.com"
  display_name      = "AWS Production"

  name {
    given_name  = "AWS"
    family_name = "Production"
  }

  emails {
    value = "aws+production@example.com"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Local user created by AWS Control Tower Account Factory
resource "aws_identitystore_user" "aws_development_example_com" {
  identity_store_id = local.sso_instance_identity_store_id
  user_name         = "aws+development@example.com"
  display_name      = "AWS Development"

  name {
    given_name  = "AWS"
    family_name = "Development"
  }

  emails {
    value = "aws+development@example.com"
  }

  lifecycle {
    prevent_destroy = true
  }
}
