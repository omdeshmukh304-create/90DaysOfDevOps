# Day 63 -- Variables, Outputs, Data Sources and Expressions

## Overview
Today I refactored my Terraform configuration to make it dynamic, reusable, and environment-aware using:
- Variables
- tfvars files
- Outputs
- Data Sources
- Locals
- Built-in Functions
- Conditional Expressions

---

# variables.tf

```hcl
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "allowed_ports" {
  description = "Allowed Ports"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "extra_tags" {
  description = "Extra Tags"
  type        = map(string)
  default     = {}
}
```

---

# terraform.tfvars

```hcl
project_name = "terraweek"

environment = "dev"

instance_type = "t2.micro"
```

---

# prod.tfvars

```hcl
project_name = "terraweek"

environment = "prod"

instance_type = "t3.small"

vpc_cidr = "10.1.0.0/16"

subnet_cidr = "10.1.1.0/24"
```

---

# Outputs After terraform apply

Example outputs:

```bash
Outputs:

instance_id = "i-0123456789"
instance_public_ip = "13.xxx.xxx.xxx"
instance_public_dns = "ec2-13-xxx-xxx-xxx.ap-south-1.compute.amazonaws.com"
security_group_id = "sg-0123456789"
subnet_id = "subnet-0123456789"
vpc_id = "vpc-0123456789"
```

(Add screenshot here)

---

# Variable Precedence

Lowest → Highest Priority

1. Default values in variables.tf
2. Environment variables (TF_VAR_*)
3. terraform.tfvars
4. *.auto.tfvars
5. -var-file
6. -var CLI arguments

## Example

Default:
```hcl
default = "t2.micro"
```

terraform.tfvars:
```hcl
instance_type = "t3.micro"
```

CLI:
```bash
terraform plan -var="instance_type=t3.small"
```

Final value used:
```bash
t3.small
```

---

# Five Useful Terraform Functions

## 1. upper()

Converts text to uppercase.

```hcl
upper("terraweek")
```

Output:
```bash
TERRAWEEK
```

---

## 2. join()

Joins list items into one string.

```hcl
join("-", ["terra", "week", "2026"])
```

Output:
```bash
terra-week-2026
```

---

## 3. length()

Counts items in a list or string.

```hcl
length(["a", "b", "c"])
```

Output:
```bash
3
```

---

## 4. lookup()

Fetches value from a map.

```hcl
lookup({dev = "t2.micro", prod = "t3.small"}, "dev")
```

Output:
```bash
t2.micro
```

---

## 5. cidrsubnet()

Creates subnet CIDRs dynamically.

```hcl
cidrsubnet("10.0.0.0/16", 8, 1)
```

Output:
```bash
10.0.1.0/24
```

---

# Difference Between variable, local, output and data

| Type | Purpose |
|---|---|
| variable | Accepts user input values |
| local | Stores reusable computed values inside Terraform |
| output | Displays values after apply |
| data | Fetches existing information from provider APIs |

## Example

### variable
```hcl
variable "region" {}
```

### local
```hcl
locals {
  name_prefix = "terraweek-dev"
}
```

### output
```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

### data
```hcl
data "aws_ami" "amazon_linux" {}
```

---

# Key Learning

Today I learned how to make Terraform infrastructure reusable and production-ready using variables, outputs, data sources, locals, and built-in functions.