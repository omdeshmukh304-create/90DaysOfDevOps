# Day 86 - GitOps Project: End-to-End CI/CD Pipeline with AI-BankApp

## Objective

The goal of Day 86 was to build and understand a complete GitOps-based CI/CD pipeline where a code change automatically flows from GitHub to production without any manual deployment steps.

---

# Complete GitOps Pipeline

```text
Developer
    │
    ▼
Git Push (GitHub)
    │
    ▼
GitHub Actions CI
    │
    ├── Checkout Repository
    ├── Build Spring Boot Application
    ├── Run Unit Tests
    ├── Build Docker Image
    ├── Push Image to Docker Hub
    ├── Update Kubernetes Deployment Manifest
    └── Commit Updated Manifest
             │
             ▼
      Git Repository Updated
             │
             ▼
ArgoCD Detects New Commit
             │
             ▼
Compares Git vs Cluster
             │
             ▼
Automatic Sync
             │
             ▼
Amazon EKS Cluster
             │
             ▼
Rolling Update
             │
             ▼
Application Available
```

---

# GitHub Actions Workflow Explained

## 1. Workflow Trigger

The workflow starts when application code is pushed to the `feat/gitops` branch.

It monitors:

* `src/**`
* `pom.xml`
* `Dockerfile`

Kubernetes manifest changes do not trigger the workflow, preventing infinite loops.

---

## 2. Checkout Repository

GitHub Actions checks out the repository onto the runner.

---

## 3. Setup Java

Java 21 is installed with Maven dependency caching enabled.

---

## 4. Build Application

The application is built using Maven.

```bash
./mvnw clean package -DskipTests -B
```

---

## 5. Run Tests

JUnit tests are executed.

```bash
./mvnw test -B
```

---

## 6. Generate Image Tag

A unique Docker image tag is created using the Git commit SHA.

Example

```
1c7cb0e
```

---

## 7. Login to Docker Hub

GitHub Actions authenticates using GitHub Secrets.

* DOCKERHUB_USERNAME
* DOCKERHUB_TOKEN

---

## 8. Build Docker Image

Example

```
omdeshmukh86/ai-bankapp-eks:1c7cb0e
```

---

## 9. Push Docker Image

The newly built image is pushed to Docker Hub.

---

## 10. Update Kubernetes Manifest

The workflow updates

```
k8s/bankapp-deployment.yml
```

Old

```yaml
image: omdeshmukh86/ai-bankapp-eks:latest
```

New

```yaml
image: omdeshmukh86/ai-bankapp-eks:1c7cb0e
```

---

## 11. Commit Updated Manifest

GitHub Actions commits the updated deployment manifest.

Example

```
ci: update bankapp image to 1c7cb0e [skip ci]
```

`[skip ci]` prevents the workflow from triggering itself again.

---

## 12. ArgoCD Deployment

ArgoCD detects the new Git commit, compares the desired state with the Kubernetes cluster, and performs an automatic rolling update.

No manual deployment commands are required.

---

---

# ArgoCD Sync

**Screenshot**

(Add screenshot showing)

* Synced
* Healthy
* New Revision

---

# Drift Detection Results

## Scenario 1 - Replica Count Changed

Command

```bash
kubectl scale deployment bankapp -n bankapp --replicas=1
```

Result

* Application became OutOfSync.
* ArgoCD detected the change.
* Replica count automatically returned to the desired value defined in Git.

---

## Scenario 2 - Image Changed

Command

```bash
kubectl set image deployment/bankapp bankapp=nginx:latest -n bankapp
```

Result

* ArgoCD detected image drift.
* Deployment was automatically restored to the correct image stored in Git.
* Pods restarted with the correct image.

---

## Scenario 3 - Service Deleted

Command

```bash
kubectl delete service bankapp-service -n bankapp
```

Result

* Service was deleted manually.
* ArgoCD recreated the Service from the Git repository.
* Application became healthy again.

---

# Complete DevOps Pipeline

```text
Developer
    │
    ▼
Git & GitHub
    │
    ▼
GitHub Actions (CI)
    │
    ▼
Docker Hub
    │
    ▼
GitOps (ArgoCD)
    │
    ▼
Amazon EKS
    │
    ▼
Helm
    │
    ▼
Prometheus
    │
    ▼
Grafana
    │
    ▼
Production Application
```

---

# Three-Day GitOps Journey

## Day 84

* Installed ArgoCD
* First GitOps deployment
* Automatic Sync
* Self-Healing

---

## Day 85

* Sync Policies
* Sync Waves
* Rollbacks
* App of Apps
* Notifications
* RBAC

---

## Day 86

* GitHub Actions CI/CD
* Automatic Docker Image Build
* Manifest Update
* GitOps Deployment
* Drift Detection
* Self-Healing
* Complete Infrastructure Teardown

---

# Teardown

Completed the cleanup using:

```bash
argocd app delete bankapp --cascade -y
argocd app delete monitoring --cascade -y
argocd app delete envoy-gateway --cascade -y
argocd app delete root-app --cascade -y
```

Destroyed the infrastructure using:

```bash
terraform destroy
```

Verified:

* EKS Cluster Deleted
* EC2 Instances Deleted
* Load Balancers Deleted
* EBS Volumes Deleted
* VPC Deleted
* AWS Billing Resources Cleaned

---

# Teardown Verification

**Screenshots**

* ArgoCD applications removed
* No resources in `bankapp` namespace
* Terraform destroy completed
* AWS Console showing no EKS cluster
* AWS Billing verification

---

# Key Takeaways

* Git is the single source of truth.
* GitHub Actions automates build, testing, image creation, and manifest updates.
* ArgoCD continuously synchronizes Kubernetes with Git.
* Self-Healing automatically corrects configuration drift.
* Rolling updates provide zero-downtime deployments.
* The complete GitOps workflow enables fully automated code-to-production deployments with minimal manual intervention.
