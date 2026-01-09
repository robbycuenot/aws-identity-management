# Generated Terraform file for AWS IAM Identity Center
# SCIM-provisioned users - read-only data sources

data "aws_identitystore_user" "alice_example_com" {
  identity_store_id = local.sso_instance_identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = "alice@example.com"
    }
  }
}

data "aws_identitystore_user" "bob_example_com" {
  identity_store_id = local.sso_instance_identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = "bob@example.com"
    }
  }
}

data "aws_identitystore_user" "charlie_example_com" {
  identity_store_id = local.sso_instance_identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = "charlie@example.com"
    }
  }
}
