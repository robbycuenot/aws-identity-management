# AWS Identity Management

Terraform configurations for AWS IAM Identity Center. Manage users, groups, permission sets, and account assignments as code.

> **How is this generated?** This repository is populated by the [aws-identity-management-generator](https://github.com/robbycuenot/aws-identity-management-generator), which reverse-engineers your current AWS IAM Identity Center state into Terraform. Run the generator to import changes made outside Terraform (SCIM, AWS console, etc.).

---

## Quick Reference

| I want to... | Go to |
|--------------|-------|
| Grant access to an account | [Account Assignments](#account-assignments) |
| Create a permission set | [Permission Sets](#permission-sets) |
| Add a user or group | [Identity Store](#identity-store) |
| Set up TEAM temporary access | [AWS TEAM](#aws-team) |
| Understand the file structure | [Repository Structure](#repository-structure) |

---

## Making Changes

1. **Create a branch** and edit the relevant `.tf` files
2. **Open a pull request** for review
3. **Merge to main** after approval
4. **Terraform applies** automatically (if using TFC) or run `terraform apply` manually

The generator runs periodically to import any AWS-side changes and keep the codebase in sync.

---

## Account Assignments

**Location:** `account_assignments/aws_ssoadmin_account_assignments_map.tf`

This is where you control who has access to what. The map structure reads naturally:

```hcl
locals {
  account_assignments_map = {
    "Production" = {
      "AdministratorAccess" = {
        "GROUP" = ["GlobalAdministrators"]
      },
      "ReadOnlyAccess" = {
        "GROUP" = ["Developers", "SecurityAuditors"],
        "USER"  = ["alice@example.com"]
      }
    },
    "Development" = {
      "DeveloperAccess" = {
        "GROUP" = ["Developers"]
      }
    }
  }
}
```

**Reading this:** "On Production, GlobalAdministrators get AdministratorAccess, and Developers/SecurityAuditors groups plus alice@example.com get ReadOnlyAccess."

### Add an Assignment

Add entries to the map:

```hcl
"Staging" = {
  "DeveloperAccess" = {
    "GROUP" = ["Developers"]
  }
}
```

### Remove an Assignment

Delete the entry from the map and apply.

---

## Permission Sets

**Location:** `permission_sets/`

Permission sets define what level of access users receive. Each permission set can have:
- **Session duration** - How long credentials are valid
- **Managed policies** - AWS-managed IAM policies
- **Inline policy** - Custom IAM policy (one per permission set)

### Create a Permission Set

1. Add the resource in `permission_sets/aws_ssoadmin_permission_sets.tf`:

```hcl
resource "aws_ssoadmin_permission_set" "CustomDeveloper" {
  instance_arn     = local.sso_instance_arn
  name             = "CustomDeveloper"
  description      = "Custom developer access"
  session_duration = "PT8H"  # 8 hours
}
```

2. Add to the map in `permission_sets/aws_ssoadmin_permission_sets_map.tf`:

```hcl
locals {
  permission_sets_map = {
    # ... existing entries ...
    "CustomDeveloper" = aws_ssoadmin_permission_set.CustomDeveloper.arn
  }
}
```

3. Attach managed policies in `permission_sets/aws_ssoadmin_managed_policy_attachments_map.tf`:

```hcl
locals {
  permission_set_managed_policy_attachments_map = {
    # ... existing entries ...
    "CustomDeveloper" = ["PowerUserAccess"]
  }
}
```

4. Optionally add an inline policy at `permission_sets/inline_policies/CustomDeveloper.json`

### Modify Session Duration

Edit the `session_duration` attribute (ISO 8601 format):

```hcl
session_duration = "PT12H"  # 12 hours
```

---

## Identity Store

**Location:** `identity_store/`

Manages users, groups, and group memberships.

### With SCIM (Entra ID, Okta, etc.)

When SCIM is enabled, users and groups sync from your identity provider. These appear as **data sources** (read-only) in Terraform:

```hcl
data "aws_identitystore_user" "alice_example_com" {
  # SCIM-managed - cannot be modified here
}
```

You can still create "local" users and groups that won't be overwritten by SCIM.

### Local Users

Local users are managed as Terraform resources. Common use cases:

- **Account Factory users** - Auto-created by AWS Control Tower (e.g., `aws+account-name@example.com`)
- **Provisioner users** - Keep permission set roles provisioned for stable ARNs (important for EKS)

### Group Memberships

**Location:** `identity_store/aws_identitystore_group_memberships_map.tf`

```hcl
locals {
  group_memberships_map = {
    "GlobalAdministrators" = ["alice@example.com", "bob@example.com"],
    "Developers" = ["alice@example.com", "charlie@example.com"]
  }
}
```

---

## AWS TEAM

**Location:** `team/`

[AWS TEAM (Temporary Elevated Access Management)](https://aws-samples.github.io/iam-identity-center-team/) is an AWS Solution that provides just-in-time, approval-based temporary access to AWS accounts. Instead of permanent elevated permissions, users request access when needed, approvers review and approve, and access is automatically revoked when the grant expires.

**How it works:**
1. User requests access (account, permission set, duration)
2. Designated approvers review and approve/deny
3. Permission set is temporarily provisioned to the account
4. Access is automatically revoked when the grant expires

### Initial Setup Warning

⚠️ **TEAM policies cannot be imported into Terraform.** The underlying DynamoDB table items don't support Terraform import. For existing TEAM deployments:

1. Run the generator to create Terraform code from existing policies
2. **Delete** the eligibility and approver policies in the TEAM console
3. Run `terraform apply` to recreate them under Terraform management

This is a one-time migration. After this, manage all policies through Terraform.

### Eligibility Policies

Define who can request what access:

```hcl
module "eligibility___Group___Developers" {
  source           = "./modules/eligibility"
  environment_data = local.eligibility_environment_data

  entity_type       = "Group"
  entity_value      = "Developers"
  max_duration      = "4"        # hours
  approval_required = true

  ou_names        = ["Development"]
  account_names   = []           # empty = all accounts in OUs
  permission_sets = ["TEAM-DeveloperAccess"]
}
```

### Approver Policies

Define who can approve requests:

```hcl
module "approvers___OU___Production" {
  source           = "./modules/approver"
  environment_data = local.approver_environment_data

  entity_type  = "OU"
  entity_value = "Production"
  approvers    = ["TEAM-Admins", "GlobalAdministrators"]
}
```

### TEAM Permission Sets

By convention, TEAM permission sets are prefixed with `TEAM-` and excluded from standard account assignments (they're assigned dynamically through the approval workflow).

---

## Repository Structure

```
├── identity_store/           # Users, groups, memberships
├── managed_policies/         # AWS managed policy references
│   └── policies/             # Policy document cache (reference only)
├── permission_sets/          # Permission sets
│   └── inline_policies/      # Custom IAM policy JSON files
├── account_assignments/      # Who has access to what
└── team/                     # AWS TEAM (if enabled)
    └── modules/              # Eligibility and approver modules
```

### Maps Pattern

This repository uses **maps with human-readable keys** throughout:

```hcl
# Easy to read and modify
locals {
  users_map = {
    "alice@example.com" = "user-id-123",
    "bob@example.com"   = "user-id-456"
  }
}
```

Maps are automatically flattened for Terraform's `for_each`. See [Technical Reference](#technical-reference) for details.

---

## Terraform Cloud Workspaces

If using multi-state mode with TFC:

| Workspace | Purpose | Apply Order |
|-----------|---------|-------------|
| `identity-store` | Users, groups | 1 |
| `managed-policies` | Policy references | 1 |
| `permission-sets` | Permission sets | 2 |
| `account-assignments` | Assignments | 3 |
| `team` | AWS TEAM | Any |

```
identity-store ──┐
                 ├──▶ permission-sets ──▶ account-assignments
managed-policies─┘
```

---

## Troubleshooting

**"Resource already exists"**
- The resource exists in AWS but not in Terraform state
- Run the generator to create import blocks, or manually import

**Changes reverted after generator runs**
- The generator imports AWS state - check if someone changed it in the console
- Your Terraform changes are preserved; AWS-side changes take precedence

**Permission set not appearing in account**
- Check account assignments map
- Verify the permission set is provisioned (may take a few minutes)

---

## Technical Reference

### Flatteners

Maps are converted to flat lists for `for_each`:

```hcl
locals {
  account_assignments_flattened = flatten([
    for account, permissions in local.account_assignments_map : [
      for permission_set, principals in permissions : [
        for principal_type, principal_list in principals : [
          for principal in principal_list : {
            account        = account
            permission_set = permission_set
            principal_type = principal_type
            principal      = principal
          }
        ]
      ]
    ]
  ])
}
```

### SCIM vs Local Resources

| Type | Terraform | Modifiable |
|------|-----------|------------|
| SCIM user/group | `data` source | No (read-only) |
| Local user/group | `resource` | Yes |

Both are unified in the same maps for consistent lookups.

### Security Notes

- Deploy from a **delegated administrator account** (not management account)
- Delegated admin cannot modify access to the management account itself
- No secrets stored in repository
- OIDC authentication (no static credentials)

---

## License

GNU General Public License v3.0 - see [LICENSE](LICENSE).
