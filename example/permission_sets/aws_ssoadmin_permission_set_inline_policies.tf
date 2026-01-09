# Generated Terraform file for AWS IAM Identity Center
resource "aws_ssoadmin_permission_set_inline_policy" "SecurityAudit" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.SecurityAudit.arn
  inline_policy      = file("${path.module}/inline_policies/SecurityAudit.json")
}
