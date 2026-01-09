# Generated Terraform file for AWS IAM Identity Center
locals {
  account_assignments_map = {
    "Management" = {
      "AdministratorAccess" = {
        "GROUP" = [
          "GlobalAdministrators",
          "AWSControlTowerAdmins"
        ]
      },
      "ReadOnlyAccess" = {
        "GROUP" = [
          "SecurityAuditors"
        ]
      }
    },
    "Audit" = {
      "AdministratorAccess" = {
        "GROUP" = [
          "GlobalAdministrators"
        ]
      },
      "SecurityAudit" = {
        "GROUP" = [
          "SecurityAuditors"
        ]
      },
      "ReadOnlyAccess" = {
        "GROUP" = [
          "Developers"
        ]
      }
    },
    "Log Archive" = {
      "AdministratorAccess" = {
        "GROUP" = [
          "GlobalAdministrators"
        ]
      },
      "ReadOnlyAccess" = {
        "GROUP" = [
          "SecurityAuditors"
        ]
      }
    },
    "Production" = {
      "AdministratorAccess" = {
        "GROUP" = [
          "GlobalAdministrators"
        ],
        "USER" = [
          "aws+production@example.com"
        ]
      },
      "ReadOnlyAccess" = {
        "GROUP" = [
          "Developers",
          "SecurityAuditors"
        ]
      }
    },
    "Staging" = {
      "AdministratorAccess" = {
        "GROUP" = [
          "GlobalAdministrators"
        ]
      },
      "DeveloperAccess" = {
        "GROUP" = [
          "Developers"
        ]
      },
      "ReadOnlyAccess" = {
        "GROUP" = [
          "SecurityAuditors"
        ]
      }
    },
    "Development" = {
      "AdministratorAccess" = {
        "GROUP" = [
          "GlobalAdministrators"
        ],
        "USER" = [
          "aws+development@example.com"
        ]
      },
      "DeveloperAccess" = {
        "GROUP" = [
          "Developers",
          "Engineering"
        ]
      },
      "ReadOnlyAccess" = {
        "GROUP" = [
          "SecurityAuditors"
        ],
        "USER" = [
          "charlie@example.com"
        ]
      }
    }
  }
}
