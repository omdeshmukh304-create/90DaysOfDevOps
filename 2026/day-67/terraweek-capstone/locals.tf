locals {
  env = terraform.workspace

  common_tags = {
    Environment = local.env
    Project     = "TerraWeek-Capstone"
  }
}