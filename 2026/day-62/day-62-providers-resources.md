# Day 62 -- Providers, Resources and Dependencies

## Objective

Today I learned how Terraform handles providers, resources, implicit dependencies, and explicit dependencies while building a complete AWS infrastructure stack.

Infrastructure created:
- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Route Table Association
- Security Group
- EC2 Instance
- S3 Bucket

---

# Provider Configuration

```hcl
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
```

---

# Full main.tf

```hcl
# -----------------------------
# VPC
# Creates a private network
# -----------------------------
resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "TerraformDemoVPC"
  }
}

# -----------------------------
# Public Subnet
# Creates subnet inside VPC
# -----------------------------
resource "aws_subnet" "demo_subnet" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "TerraformDemoSubnet"
  }
}

# -----------------------------
# Internet Gateway
# Provides internet access
# -----------------------------
resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "TerraformDemoIGW"
  }
}

# -----------------------------
# Route Table
# Controls traffic routing
# -----------------------------
resource "aws_route_table" "demo_route_table" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }

  tags = {
    Name = "TerraformDemoRouteTable"
  }
}

# -----------------------------
# Route Table Association
# Connects subnet with route table
# -----------------------------
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.demo_subnet.id
  route_table_id = aws_route_table.demo_route_table.id
}

# -----------------------------
# Security Group
# Controls inbound/outbound traffic
# -----------------------------
resource "aws_security_group" "demo_security_group" {
  name        = "TerraWeek-5G"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.demo_vpc.id

  # SSH Access
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP Access
  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TerraformDemoSG"
  }
}

# -----------------------------
# EC2 Instance
# Creates virtual server
# -----------------------------
resource "aws_instance" "demo_instance" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"

  subnet_id = aws_subnet.demo_subnet.id

  vpc_security_group_ids = [
    aws_security_group.demo_security_group.id
  ]

  associate_public_ip_address = true

  tags = {
    Name = "TerraWeek-Day5"
  }
}

# -----------------------------
# S3 Bucket
# Stores application logs
# -----------------------------
resource "aws_s3_bucket" "app_logs" {
  bucket = "terraweek-app-logs-omdeshmukh-2026"

  depends_on = [aws_instance.demo_instance]

  tags = {
    Name = "TerraWeek-App-Logs"
  }
}
```

---

# Terraform Apply Output

## Screenshot

Add screenshot here:

```text
[PASTE SCREENSHOT OF TERRAFORM APPLY OUTPUT]
```

Example output:

```bash
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.
```

---

# AWS Console Verification

## Screenshot

Add screenshot here:

```text
[PASTE SCREENSHOT OF AWS VPC + EC2 + SUBNET + ROUTE TABLE]
```

Verified resources:
- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group
- EC2 Instance
- S3 Bucket

---

# Terraform Dependency Graph

## Command Used

```bash
terraform graph | dot -Tpng > graph.png
```

If Graphviz is not installed:

```bash
terraform graph
```

---

# Dependency Graph

```text
aws_vpc.demo_vpc
 ├── aws_subnet.demo_subnet
 │      └── aws_instance.demo_instance
 │
 ├── aws_internet_gateway.demo_igw
 │
 ├── aws_route_table.demo_route_table
 │      └── aws_route_table_association.public_assoc
 │
 ├── aws_security_group.demo_security_group
 │      └── aws_instance.demo_instance
 │
 └── aws_s3_bucket.app_logs
        depends_on → aws_instance.demo_instance
```

---

# Implicit Dependencies

Implicit dependencies happen automatically when one resource references another resource attribute.

Example:

```hcl
subnet_id = aws_subnet.demo_subnet.id
```

Terraform automatically understands:
- Subnet must exist before EC2 instance

Other implicit dependencies:
- Subnet depends on VPC
- Internet Gateway depends on VPC
- Route Table depends on VPC
- EC2 depends on Security Group

Terraform creates resources in the correct order automatically.

---

# Explicit Dependencies

Explicit dependencies are manually defined using:

```hcl
depends_on
```

Example:

```hcl
depends_on = [aws_instance.demo_instance]
```

This tells Terraform:
- Create EC2 instance first
- Then create S3 bucket

even though there is no direct reference between them.

---

# Version Constraints

## ~> 5.0

Allows any provider version inside the 5.x range but blocks upgrades to 6.x.

Examples allowed:
- 5.1
- 5.50
- 5.99

---

# .terraform.lock.hcl

Terraform creates this file after `terraform init`.

Purpose:
- Locks provider versions
- Ensures consistent deployments
- Prevents unexpected upgrades
- Improves team collaboration and CI/CD stability

---

# Commands Used

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform graph
```

---

# What I Learned

- How Terraform providers work
- Difference between resources and providers
- How Terraform builds dependency graphs
- Implicit vs explicit dependencies
- How to deploy complete AWS infrastructure using Terraform
- How EC2, VPC, subnet, route table, and security groups connect together
- How Terraform automatically determines resource creation order