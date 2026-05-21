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

# resource "aws_s3_bucket" "demo_bucket" {
#   bucket = "om-terraform-demo-bucket-2026"

#   tags = {
#     Name = "TerraformDemoBucket"
#   }
# }


# resource "aws_instance" "demo_instance" {
#   ami           = "ami-0f5ee92e2d63afc18"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "TerraWeek-Day1"
#   }
# }