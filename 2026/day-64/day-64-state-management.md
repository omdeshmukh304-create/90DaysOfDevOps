# Day 64 - Terraform State Management and Remote Backends

## Overview
Today I learned how Terraform manages infrastructure state, how to move state to a remote backend using S3, enable DynamoDB state locking, import existing AWS resources into Terraform, perform state surgery, and handle state drift.

---

# Architecture Diagram

## Local State Setup

```text
┌──────────────────────┐
│   Local Machine      │
│                      │
│ terraform.tfstate    │
│ stored locally       │
└──────────────────────┘
```

Problems:
- Single point of failure
- No team collaboration
- Easy to lose or corrupt
- No locking

---

# Remote Backend Setup

```text
                 ┌────────────────────┐
                 │   Terraform CLI    │
                 └─────────┬──────────┘
                           │
                           │
             ┌─────────────▼─────────────┐
             │     S3 Remote Backend     │
             │ terraform.tfstate stored  │
             │ centrally in AWS S3       │
             └─────────────┬─────────────┘
                           │
                           │ State Lock
                           │
             ┌─────────────▼─────────────┐
             │      DynamoDB Table       │
             │   terraform-state-lock    │
             │ Prevents concurrent apply │
             └───────────────────────────┘
```

Benefits:
- Shared centralized state
- Team collaboration
- Versioning and recovery
- State locking
- Safer production workflows

---

# Task 1 - Inspect Terraform State

## Commands Used

```bash
terraform show
terraform state list
terraform state show aws_instance.web
terraform state show aws_vpc.main
```

## What I Learned

Terraform state stores much more information than what is written in `.tf` files.

Example:
- Instance ID
- Public IP
- Private IP
- Security groups
- Tags
- ARN
- AMI
- Networking information

The `serial` number inside `terraform.tfstate` increases whenever the state changes.

---

# Task 2 - Configure Remote Backend

## Step 1 - Create S3 Bucket

```bash
aws s3api create-bucket \
  --bucket terraweek-state-omdeshmukh \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1
```

## Step 2 - Enable Versioning

```bash
aws s3api put-bucket-versioning \
  --bucket terraweek-state-omdeshmukh \
  --versioning-configuration Status=Enabled
```

## Step 3 - Create DynamoDB Lock Table

```bash
aws dynamodb create-table \
  --table-name terraweek-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-south-1
```

## Backend Configuration

```hcl
terraform {
  backend "s3" {
    bucket         = "terraweek-state-omdeshmukh"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraweek-state-lock"
    encrypt        = true
  }
}
```

## Initialize Backend

```bash
terraform init
```

Terraform migrated local state to S3 successfully.

---

# Screenshot - State File in S3

(Add screenshot here)

Bucket:
```text
terraweek-state-omdeshmukh
```

Object:
```text
dev/terraform.tfstate
```

---

# Task 3 - State Locking

## Objective

Prevent multiple users from modifying Terraform state simultaneously.

## Commands Used

Terminal 1:

```bash
terraform apply
```

Terminal 2:

```bash
terraform apply
```

## Result

Terraform blocked the second operation and showed:

```text
Error acquiring the state lock
```

## Why Locking Is Important

Without locking:
- State corruption can happen
- Multiple engineers may overwrite state
- Infrastructure can become inconsistent

DynamoDB locking ensures only one Terraform operation modifies state at a time.

---

# Screenshot - Lock Error

(Add screenshot here)

---

# Task 4 - Terraform Import

## Objective

Bring an existing AWS resource under Terraform management.

## Step 1 - Manually Create Bucket

Bucket Name:

```text
terraweek-import-test-omdeshmukh
```

## Step 2 - Create Terraform Resource

```hcl
resource "aws_s3_bucket" "imported" {
  bucket = "terraweek-import-test-omdeshmukh"
}
```

## Step 3 - Import Existing Resource

```bash
terraform import aws_s3_bucket.imported terraweek-import-test-omdeshmukh
```

## Result

Terraform successfully imported the bucket into state.

## Verification

```bash
terraform state list
```

Output included:

```text
aws_s3_bucket.imported
```

---

# Task 5 - State Surgery

## Rename Resource Using `state mv`

```bash
terraform state mv \
aws_s3_bucket.imported \
aws_s3_bucket.logs_bucket
```

Purpose:
- Rename resources
- Refactor Terraform code
- Move resources between modules

---

## Remove Resource From State Using `state rm`

```bash
terraform state rm aws_s3_bucket.logs_bucket
```

Purpose:
- Stop Terraform from managing a resource
- Remove broken state entries
- Move resources between Terraform projects

Important:
This removes only the Terraform state entry.
The real AWS resource still exists.

---

# Task 6 - Simulate and Fix State Drift

## What Is Drift?

State drift occurs when infrastructure changes outside Terraform.

Example:
- AWS Console edits
- AWS CLI changes
- Manual production fixes

---

## Drift Example

I manually changed the EC2 Name tag in AWS console from:

```text
day64-ec2-lock-test
```

to:

```text
ManuallyChanged
```

## Terraform Detected Drift

```bash
terraform plan
```

Terraform output:

```text
~ "Name" = "ManuallyChanged"
  -> "day64-ec2-lock-test"
```

---

## Fixing Drift

I ran:

```bash
terraform apply
```

Terraform restored infrastructure back to the desired configuration.

Verification:

```bash
terraform plan
```

Output:

```text
No changes. Your infrastructure matches the configuration.
```

---

# Important Terraform State Commands

| Command | Purpose |
|---|---|
| `terraform import` | Bring existing resource under Terraform management |
| `terraform state mv` | Rename/move resources in state |
| `terraform state rm` | Remove resource from Terraform tracking |
| `terraform force-unlock` | Remove stale state lock |
| `terraform refresh` | Sync state with real infrastructure |
| `terraform state list` | List tracked resources |
| `terraform state show` | Show resource details |

---

# Real Production Best Practices

Teams prevent state drift and corruption by:

- Restricting AWS console access
- Using CI/CD pipelines
- Running all infrastructure changes through Terraform
- Using pull requests and approvals
- Monitoring Terraform plans regularly
- Using remote backends with locking

---

---

# Direct Answers to Task Questions

## Task 1 Answers

### 1. How many resources does Terraform track?

Terraform tracked the following resources:

- VPC
- Subnet
- Internet Gateway
- Route Table
- Route Table Association
- Security Group
- EC2 Instance
- Imported S3 Bucket

Total resources tracked:

```text
8 resources
```

---

### 2. What attributes does Terraform state store for an EC2 instance?

Terraform stores many attributes including:

- Instance ID
- Public IP
- Private IP
- AMI ID
- Security Groups
- Tags
- Subnet ID
- Availability Zone
- ARN
- DNS name
- Root block device information

Terraform stores much more than what is defined in the `.tf` file.

---

### 3. What does the `serial` number represent?

The `serial` number in `terraform.tfstate` represents the version of the state file.

Every time Terraform modifies infrastructure or state, the serial number increases.

---

# Task 3 Answer

## Why is state locking critical for team environments?

State locking prevents multiple users or pipelines from modifying Terraform state simultaneously.

Without locking:
- State corruption may occur
- Infrastructure changes may conflict
- Production environments may become inconsistent

DynamoDB locking ensures only one Terraform operation runs at a time.

---

# Task 4 Answer

## Difference between `terraform import` and creating a resource from scratch

| terraform import | terraform apply |
|---|---|
| Imports existing infrastructure | Creates new infrastructure |
| Only updates Terraform state | Creates actual AWS resource |
| Used for adoption/migration | Used for provisioning |

---

# Task 5 Answers

## When to use `terraform state mv`

Use cases:
- Renaming resources
- Moving resources into modules
- Refactoring Terraform projects
- Changing resource structure without recreation

---

## When to use `terraform state rm`

Use cases:
- Stop Terraform from managing a resource
- Remove broken state entries
- Move resources to another Terraform project
- Keep AWS resource but remove Terraform tracking

---

# Task 6 Answer

## How do teams prevent state drift in production?

Teams prevent drift by:

- Restricting AWS console access
- Using CI/CD pipelines for infrastructure changes
- Enforcing Infrastructure as Code policies
- Using pull requests and approvals
- Running regular `terraform plan` checks
- Avoiding manual production changes

# Final Learning

Terraform is not only an infrastructure provisioning tool.

Terraform is a:

```text
State management and infrastructure reconciliation system
```

Understanding state management is critical for production-grade DevOps workflows.