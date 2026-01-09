# Generated Terraform file for AWS IAM Identity Center
resource "aws_ssoadmin_managed_policy_attachment" "controller" {
  for_each = { for attachment in local.permission_set_managed_policy_attachments_flattened : "${attachment.permission_set}___${attachment.policy}" => attachment }

  instance_arn       = local.sso_instance_arn
  permission_set_arn = local.permission_sets_map[each.value.permission_set]
  managed_policy_arn = var.managed_policies_map[each.value.policy]
}
