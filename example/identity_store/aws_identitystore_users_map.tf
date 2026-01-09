# Generated Terraform file for AWS IAM Identity Center
locals {
  users_map = {
    # SCIM-provisioned users (data sources)
    "alice@example.com"   = data.aws_identitystore_user.alice_example_com.user_id,
    "bob@example.com"     = data.aws_identitystore_user.bob_example_com.user_id,
    "charlie@example.com" = data.aws_identitystore_user.charlie_example_com.user_id,
    # Local users (resources)
    "aws+production@example.com"  = aws_identitystore_user.aws_production_example_com.user_id,
    "aws+development@example.com" = aws_identitystore_user.aws_development_example_com.user_id
  }
}
