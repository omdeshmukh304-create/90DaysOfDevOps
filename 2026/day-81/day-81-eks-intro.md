# Day 81 – Introduction to Amazon EKS with Terraform

## Objective

The objective of this task was to understand Amazon EKS architecture, review the AI-BankApp Terraform configuration, provision an EKS cluster using Terraform, connect to the cluster, and understand the cost of running Kubernetes on AWS.

---

# Amazon EKS Architecture

```
                         Internet
                             |
                     Internet Gateway
                             |
                    -------------------
                    |                 |
                Public Subnets (3 AZs)
                    |
               NAT Gateway
                    |
        ----------------------------
        |          |              |
   Private Subnet  Private Subnet  Private Subnet
        |          |              |
   -----------------------------------------
   |            EKS Cluster                |
   |                                       |
   |  AWS Managed Control Plane            |
   |  - API Server                         |
   |  - Scheduler                          |
   |  - Controller Manager                 |
   |  - etcd                              |
   -----------------------------------------
                 |
          Managed Node Group
        (EC2 Worker Nodes)
                 |
      --------------------------
      |        |        |
   CoreDNS  kube-proxy  VPC CNI
      |
 AWS EBS CSI Driver
      |
 Metrics Server
      |
 AI-BankApp Pods
 (MySQL, Ollama, Spring Boot)
```

---

# Terraform Files

## provider.tf

Configures the AWS and Helm providers and defines the AWS region used by Terraform.

---

## variables.tf

Contains all configurable input variables such as:

* AWS Region
* Cluster Name
* Kubernetes Version
* Node Instance Type
* Desired Node Count

---

## terraform.tfvars

Provides values for the variables defined in variables.tf.

Example:

* Region: us-west-2
* Cluster Name: bankapp-eks
* Kubernetes Version: 1.35
* Node Instance Type: t3.medium (changed during testing)

---

## vpc.tf

Creates the networking infrastructure.

It provisions:

* VPC
* Internet Gateway
* NAT Gateway
* Public Subnets
* Private Subnets
* Intra Subnets
* Route Tables

The VPC is spread across three Availability Zones for High Availability.

---

## eks.tf

Creates the EKS Cluster.

It provisions:

* EKS Control Plane
* Managed Node Group
* IAM Roles
* Security Groups
* EKS Add-ons

Installed Add-ons:

* CoreDNS
* kube-proxy
* VPC CNI
* EBS CSI Driver
* Metrics Server
* EKS Pod Identity Agent

---

## argocd.tf

Deploys ArgoCD into the EKS cluster using the Helm provider.

ArgoCD will be used later for GitOps deployment.

---

## outputs.tf

Provides useful outputs after deployment including:

* update-kubeconfig command
* ArgoCD password command
* Cluster information

---

# Terraform Workflow

```
terraform init

↓

terraform plan

↓

terraform apply

↓

aws eks update-kubeconfig

↓

kubectl
```

---

# Practical Work Completed

Completed successfully:

* Studied EKS Architecture
* Reviewed Terraform configuration
* Initialized Terraform
* Generated Terraform execution plan
* Provisioned VPC and networking resources
* Provisioned EKS Control Plane

Challenges encountered:

* Managed Node Group creation failed because of AWS account EC2 instance restrictions.
* EKS Add-ons (CoreDNS, Metrics Server and EBS CSI Driver) remained in the DEGRADED state because worker nodes were unavailable.

---

# Screenshots

## kubectl get nodes

![alt text](<WhatsApp Image 2026-06-25 at 10.57.11 PM.jpeg>)
---

## kubectl get pods -n kube-system

![alt text](<WhatsApp Image 2026-06-25 at 10.57.09 PM.jpeg>)

---

---

## kubectl get pvc -n bankapp

![alt text](<WhatsApp Image 2026-06-25 at 10.57.10 PM.jpeg>)

---

# Amazon EKS Cost Breakdown

| Component            | Approximate Cost      |
| -------------------- | --------------------- |
| EKS Control Plane    | ~$73/month            |
| 3 × EC2 Worker Nodes | ~$91/month            |
| NAT Gateway          | ~$33/month            |
| EBS Volumes          | ~$1.50/month          |
| Load Balancer        | ~$18/month            |
| Total                | ~$220/month (~$7/day) |

---

# Why is the NAT Gateway expensive?

The NAT Gateway runs continuously and is billed per hour regardless of traffic. AWS also charges separately for data processed through the NAT Gateway, making it one of the more expensive components in small Kubernetes lab environments.

---

# ArgoCD

ArgoCD was configured in Terraform but could not be verified because the EKS worker nodes were not successfully created.

---

# Learning Outcomes

* Learned Amazon EKS architecture.
* Understood managed Kubernetes.
* Studied Terraform modules for VPC, EKS and ArgoCD.
* Learned how Terraform provisions AWS infrastructure.
* Understood EKS networking and IAM integration.
* Learned the dependencies between worker nodes and Kubernetes add-ons.
* Learned troubleshooting techniques for failed EKS deployments.
