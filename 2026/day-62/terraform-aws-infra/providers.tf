terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
# ## AWS Provider Version Constraints
# ### ~> 5.0
# Allows Terraform to install any AWS provider version in the 5.x range while preventing major version upgrades to 6.x.
# ### >= 5.0
# Allows any version greater than or equal to 5.0, including future major releases.
# ### = 5.0.0
# Pins Terraform to exactly version 5.0.0 with no upgrades allowed.
# ## .terraform.lock.hcl
# Terraform creates this file after initialization to lock provider versions and ensure consistent infrastructure deployments across systems and teams.

