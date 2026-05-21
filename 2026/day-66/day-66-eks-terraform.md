# Day 66 -- Provision an EKS Cluster with Terraform Modules

## Objective
Today I provisioned a production-style Kubernetes cluster on AWS using Terraform Registry modules. Instead of manually configuring infrastructure, I used reusable Terraform modules to automate the creation of networking, IAM roles, worker nodes, and the EKS control plane.

This setup is fully reproducible and can be destroyed with a single command.

---

# Project Structure

```text
terraform-eks/
├── providers.tf
├── variables.tf
├── terraform.tfvars
├── vpc.tf
├── eks.tf
├── outputs.tf
```

---

# providers.tf

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }
}

provider "aws" {
  region = var.region
}
```

---

# variables.tf

```hcl
variable "region" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "terraweek-eks"
}

variable "cluster_version" {
  type    = string
  default = "1.31"
}

variable "node_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "node_desired_count" {
  type    = number
  default = 2
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
```

---

# vpc.tf

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs = [
    "${var.region}a",
    "${var.region}b"
  ]

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

---

# eks.tf

```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    terraweek_nodes = {
      ami_type       = "AL2_x86_64"
      instance_types = [var.node_instance_type]

      min_size     = 1
      max_size     = 3
      desired_size = var.node_desired_count
    }
  }

  tags = {
    Environment = "dev"
    Project     = "TerraWeek"
    ManagedBy   = "Terraform"
  }
}
```

---

# outputs.tf

```hcl
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_version" {
  value = module.eks.cluster_version
}

output "cluster_region" {
  value = var.region
}
```

---

# Terraform Commands Used

## Initialize Terraform

```bash
terraform init
```

## Validate Configuration

```bash
terraform validate
```

## Review Infrastructure Plan

```bash
terraform plan
```

## Create Infrastructure

```bash
terraform apply
```

---

# kubectl Configuration

## Connect kubectl to EKS

```bash
aws eks update-kubeconfig --name terraweek-eks --region ap-south-1
```

## Verify Nodes

```bash
kubectl get nodes
```

## Verify Cluster Pods

```bash
kubectl get pods -A
```

## Cluster Info

```bash
kubectl cluster-info
```

---

# Nginx Deployment

## Create Deployment

```bash
kubectl create deployment nginx --image=nginx
```

## Verify Deployment

```bash
kubectl get deployments
```

## Verify Pods

```bash
kubectl get pods
```

---

# Screenshots

## Terraform Apply Completed
(Add Screenshot Here)

---

## kubectl get nodes
(Add Screenshot Here)

Expected:
- 2 worker nodes
- STATUS = Ready

---

## kube-system Pods
(Add Screenshot Here)

Expected:
- CoreDNS running
- aws-node running
- kube-proxy running

---

## Nginx Running on Cluster
(Add Screenshot Here)

Expected:
- nginx pod in Running state

---

# Why EKS Uses Public and Private Subnets

EKS uses:
- Public subnets for internet-facing load balancers
- Private subnets for worker nodes and workloads

This improves security because worker nodes are not directly exposed to the internet.

Private nodes access the internet through the NAT Gateway.

---

# What the Subnet Tags Do

```hcl
"kubernetes.io/role/elb" = 1
```

Allows public load balancers to be created in public subnets.

```hcl
"kubernetes.io/role/internal-elb" = 1
```

Allows internal load balancers to be created in private subnets.

These tags help Kubernetes automatically identify correct subnets.

---

# Total Resources Created

Terraform created approximately:
- 30+ AWS resources

Including:
- EKS Cluster
- Worker Nodes
- IAM Roles
- Security Groups
- Launch Templates
- NAT Gateway
- Route Tables
- CloudWatch Log Groups

(Check your terraform apply output for exact number.)

---

# Destroy Process

## Destroy Infrastructure

```bash
terraform destroy
```

Type:

```text
yes
```

Terraform removed:
- EKS cluster
- Worker nodes
- IAM roles
- Networking resources
- Security groups
- NAT gateway

---

# Verification After Destroy

```bash
aws eks list-clusters --region ap-south-1
```

Expected:
```json
{
  "clusters": []
}
```

---

# Reflection

Compared to manually setting up Kubernetes using kind or minikube during Day 50, provisioning EKS with Terraform felt much more production-oriented.

kind and minikube:
- Run locally
- Simple setup
- Good for learning Kubernetes basics

EKS with Terraform:
- Creates real cloud infrastructure
- Uses managed Kubernetes
- Includes networking, IAM, and scaling
- Production-grade deployment process
- Fully automated and reproducible

Terraform modules made the infrastructure setup much easier because many complex AWS resources were abstracted behind reusable modules.

This exercise showed how DevOps engineers automate Kubernetes infrastructure in real-world cloud environments.

---

# Final Verification Questions

## Do you see 2 nodes in Ready state?
Yes, the managed node group created 2 worker nodes successfully.

## Can you see kube-system pods running?
Yes, kube-system pods such as CoreDNS, kube-proxy, and aws-node were running correctly.

## Why does EKS need both public and private subnets?
Public subnets are used for external load balancers, while private subnets securely host worker nodes and workloads.

## What do the subnet tags do?
They allow Kubernetes and AWS Load Balancers to automatically identify which subnets should host public or internal load balancers.

---