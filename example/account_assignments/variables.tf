# Generated Terraform file for AWS IAM Identity Center
variable "users_map" {
  description = "Map of user names to user IDs"
  type        = map(string)
}

variable "groups_map" {
  description = "Map of group names to group IDs"
  type        = map(string)
}

variable "permission_sets_map" {
  description = "Map of permission set names to ARNs"
  type        = map(string)
}
