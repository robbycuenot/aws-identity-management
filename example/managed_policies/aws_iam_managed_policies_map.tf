# Generated Terraform file for AWS IAM Identity Center
# Static managed policies map - ARNs are hardcoded for faster planning

locals {
  managed_policies_map = {
    "AdministratorAccess"              = "arn:aws:iam::aws:policy/AdministratorAccess",
    "Billing"                          = "arn:aws:iam::aws:policy/job-function/Billing",
    "PowerUserAccess"                  = "arn:aws:iam::aws:policy/PowerUserAccess",
    "ViewOnlyAccess"                   = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess",
    "ReadOnlyAccess"                   = "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "AWSOrganizationsFullAccess"       = "arn:aws:iam::aws:policy/AWSOrganizationsFullAccess",
    "AWSServiceCatalogAdminFullAccess" = "arn:aws:iam::aws:policy/AWSServiceCatalogAdminFullAccess",
    "AWSSSOReadOnly"                   = "arn:aws:iam::aws:policy/AWSSSOReadOnly",
    "AWSSSODirectoryReadOnly"          = "arn:aws:iam::aws:policy/AWSSSODirectoryReadOnly",
    "IAMReadOnlyAccess"                = "arn:aws:iam::aws:policy/IAMReadOnlyAccess",
    "AmazonS3FullAccess"               = "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "AmazonEC2FullAccess"              = "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "AmazonDynamoDBReadOnlyAccess"     = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
  }
}
