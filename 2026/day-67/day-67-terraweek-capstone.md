# Day 67 -- TerraWeek Capstone: Multi-Environment Infrastructure with Workspaces and Modules

## Objective
Build a production-style multi-environment AWS infrastructure using:
- Terraform workspaces
- Custom reusable modules
- Environment-specific configurations
- Workspace-aware infrastructure deployment

---

# Project Structure

```bash
terraweek-capstone/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── locals.tf
├── dev.tfvars
├── staging.tfvars
├── prod.tfvars
├── .gitignore
│
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── security-group/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── ec2-instance/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

# Root Module Configuration

## providers.tf

```hcl
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

---

## locals.tf

```hcl
locals {
  environment = terraform.workspace

  name_prefix = "${var.project_name}-${local.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
    Workspace   = terraform.workspace
  }
}
```

---

## variables.tf

```hcl
variable "project_name" {
  type    = string
  default = "terraweek"
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "ami_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ingress_ports" {
  type    = list(number)
  default = [22, 80]
}
```

---

## main.tf

```hcl
module "vpc" {
  source = "./modules/vpc"

  cidr               = var.vpc_cidr
  public_subnet_cidr = var.subnet_cidr

  environment  = local.environment
  project_name = var.project_name
}

module "security_group" {
  source = "./modules/security-group"

  vpc_id        = module.vpc.vpc_id
  ingress_ports = var.ingress_ports

  environment  = local.environment
  project_name = var.project_name
}

module "ec2_instance" {
  source = "./modules/ec2-instance"

  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.subnet_id
  security_group_ids = [module.security_group.sg_id]

  environment  = local.environment
  project_name = var.project_name
}
```

---

# Custom Modules

# Module 1 -- VPC Module

## Features
- VPC
- Public subnet
- Internet gateway
- Route table
- Route table association

## Outputs
- vpc_id
- subnet_id

---

# Module 2 -- Security Group Module

## Features
- Dynamic ingress rules
- Environment-aware security rules
- Allow-all egress

## Outputs
- sg_id

---

# Module 3 -- EC2 Instance Module

## Features
- EC2 provisioning
- Environment-based instance types
- Reusable infrastructure

## Outputs
- instance_id
- public_ip

---

# Environment Configurations

## dev.tfvars

```hcl
ami_id        = "ami-0f58b397bc5c1f2e8"

vpc_cidr      = "10.0.0.0/16"
subnet_cidr   = "10.0.1.0/24"

instance_type = "t2.micro"

ingress_ports = [22, 80]
```

### Characteristics
- Smallest instance
- SSH enabled
- Development/testing environment

---

## staging.tfvars

```hcl
ami_id        = "ami-0f58b397bc5c1f2e8"

vpc_cidr      = "10.1.0.0/16"
subnet_cidr   = "10.1.1.0/24"

instance_type = "t2.small"

ingress_ports = [22, 80, 443]
```

### Characteristics
- Medium-size environment
- HTTPS enabled
- Pre-production validation

---

## prod.tfvars

```hcl
ami_id        = "ami-0f58b397bc5c1f2e8"

vpc_cidr      = "10.2.0.0/16"
subnet_cidr   = "10.2.1.0/24"

instance_type = "t3.small"

ingress_ports = [80, 443]
```

### Characteristics
- Production-sized instance
- SSH disabled
- Hardened security posture

---

# Deployment Commands

## Dev

```bash
terraform workspace select dev
terraform apply -var-file="dev.tfvars"
```

---

## Staging

```bash
terraform workspace select staging
terraform apply -var-file="staging.tfvars"
```

---

## Prod

```bash
terraform workspace select prod
terraform apply -var-file="prod.tfvars"
```

---

# Terraform Outputs

```bash
terraform output
```

Outputs:
- VPC ID
- Subnet ID
- Security Group ID
- Instance ID
- Public IP

---

# AWS Verification

Verified:
- Three separate VPCs
- Three isolated subnets
- Three independent security groups
- Three EC2 instances
- Different CIDR ranges
- Different instance types
- Different ingress rules

Environment isolation was successfully achieved using Terraform workspaces.

---

# Terraform Best Practices Guide

## 1. File Structure
- Separate providers, variables, outputs, locals, and main configs
- Keep infrastructure modular and scalable

## 2. State Management
- Use remote backend
- Enable state locking
- Enable versioning

## 3. Variables
- Never hardcode values
- Use tfvars files
- Validate variables

## 4. Modules
- One concern per module
- Always define inputs and outputs
- Pin module versions

## 5. Workspaces
- Use for environment isolation
- Reference terraform.workspace

## 6. Security
- Ignore tfstate and tfvars
- Encrypt remote state
- Restrict backend access

## 7. Commands
Always run:
```bash
terraform fmt
terraform validate
terraform plan
```

before:
```bash
terraform apply
```

## 8. Tagging
Tag every resource:
- Project
- Environment
- ManagedBy

## 9. Naming
Use:
```bash
<project>-<environment>-<resource>
```

## 10. Cleanup
Destroy unused infrastructure:
```bash
terraform destroy
```

---

# TerraWeek Learning Summary

| Day | Concepts |
|-----|----------|
| 61 | IaC, HCL, init/plan/apply/destroy, state basics |
| 62 | Providers, resources, dependencies, lifecycle |
| 63 | Variables, outputs, data sources, locals, functions |
| 64 | Remote backend, locking, import, drift |
| 65 | Custom modules, registry modules, versioning |
| 66 | EKS with modules, real-world provisioning |
| 67 | Workspaces, multi-env, capstone project |

---

# Key Takeaways

This capstone demonstrated:
- Real-world Infrastructure as Code
- Reusable Terraform modules
- Multi-environment deployment
- Workspace isolation
- AWS infrastructure automation
- Production-grade Terraform architecture
- DevOps best practices

Terraform can now be used to manage scalable and repeatable cloud infrastructure efficiently across multiple environments.