# Generated Terraform file for AWS IAM Identity Center
# SCIM-provisioned groups - read-only data sources

data "aws_identitystore_group" "Engineering" {
  identity_store_id = local.sso_instance_identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "Engineering"
    }
  }
}
