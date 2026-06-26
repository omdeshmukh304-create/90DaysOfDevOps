# Day 84 – Introduction to GitOps and ArgoCD

## Objective

Today I learned the fundamentals of GitOps and ArgoCD. Instead of deploying Kubernetes manifests manually using `kubectl apply`, I configured ArgoCD to continuously monitor a Git repository and synchronize the Kubernetes cluster with the desired state stored in Git.

---

# 1. GitOps Principles (In My Own Words)

GitOps is a deployment methodology where **Git becomes the single source of truth** for both infrastructure and application configuration.

Instead of manually applying Kubernetes manifests, ArgoCD continuously watches the Git repository. Whenever a new commit is pushed, ArgoCD compares the desired state stored in Git with the actual state of the Kubernetes cluster.

If any manual changes are made directly inside the cluster, ArgoCD automatically detects the difference and restores the cluster back to the state defined in Git.

Benefits of GitOps:

* Git is the single source of truth.
* Every change is version controlled.
* Complete audit history.
* Easy rollback using Git.
* Automatic deployment.
* Self-healing infrastructure.

---

# 2. GitOps vs Traditional CI/CD

| Feature         | Traditional CI/CD                 | GitOps                           |
| --------------- | --------------------------------- | -------------------------------- |
| Source of Truth | CI Pipeline                       | Git Repository                   |
| Deployment      | Pipeline runs `kubectl apply`     | ArgoCD continuously syncs Git    |
| Rollback        | Manual or pipeline rerun          | `git revert`                     |
| Drift Detection | Not available                     | Automatic                        |
| Cluster Access  | CI Server needs Kubernetes access | Only ArgoCD accesses the cluster |
| Security        | More credentials required         | More secure                      |
| Audit Trail     | Pipeline logs                     | Git History                      |

---

# 3. AI-BankApp GitOps Flow

```text
Developer
    │
    ▼
Push Code to GitHub (feat/gitops)
    │
    ▼
GitHub Actions
    │
    ├── Build Project
    ├── Run Tests
    ├── Build Docker Image
    ├── Push Image to DockerHub
    └── Update Image Tag
    │
    ▼
Git Repository Updated
    │
    ▼
ArgoCD Detects New Commit
    │
    ▼
Compare Git vs Cluster
    │
    ▼
Sync Kubernetes Resources
    │
    ▼
Rolling Update
    │
    ▼
Application Updated
```

---

# 4. ArgoCD Application Manifest

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application

metadata:
  name: bankapp
  namespace: argocd

spec:
  project: default

  source:
    repoURL: https://github.com/omdeshmukh304-create/AI-BankApp-DevOps.git
    targetRevision: feat/gitops
    path: k8s

  destination:
    server: https://kubernetes.default.svc
    namespace: bankapp

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true
      - ServerSideApply=true
```

---

# 5. Explanation of Every Field

| Field                 | Purpose                                           |
| --------------------- | ------------------------------------------------- |
| apiVersion            | ArgoCD API Version                                |
| kind                  | Kubernetes resource type (Application)            |
| metadata.name         | Name of the ArgoCD application                    |
| metadata.namespace    | Namespace where ArgoCD manages the Application    |
| project               | ArgoCD project (default)                          |
| repoURL               | GitHub repository containing Kubernetes manifests |
| targetRevision        | Git branch watched by ArgoCD                      |
| path                  | Directory containing Kubernetes YAML files        |
| destination.server    | Target Kubernetes cluster                         |
| destination.namespace | Namespace where resources are deployed            |
| automated             | Automatically synchronize changes                 |
| prune                 | Delete resources removed from Git                 |
| selfHeal              | Restore manual changes automatically              |
| CreateNamespace       | Automatically create namespace if missing         |
| ServerSideApply       | Use Kubernetes Server Side Apply                  |

---

# 6. Important Sync Options

## prune

Deletes Kubernetes resources that have been removed from the Git repository.

Example:

If Deployment YAML is deleted from Git, ArgoCD automatically deletes it from the cluster.

---

## selfHeal

Automatically restores manual changes.

Example:

If someone changes replicas from 4 to 1 using kubectl, ArgoCD changes it back to the value stored in Git.

---

## ServerSideApply

Uses Kubernetes Server Side Apply instead of client-side apply.

Advantages:

* Better conflict handling
* Cleaner updates
* Better compatibility with multiple controllers

---

# 7. Practical Work Performed

* Installed ArgoCD on local Kind cluster.
* Logged into the ArgoCD Web UI.
* Forked the AI-BankApp repository.
* Created an ArgoCD Application.
* Connected ArgoCD with the GitHub repository.
* Installed Gateway API CRDs.
* Installed cert-manager.
* Installed Envoy Gateway.
* Synced the application using ArgoCD.
* Investigated synchronization issues caused by EKS-specific StorageClass (`gp3`) while running on a Kind cluster.

---

# 8. Self-Healing

### Test

* Manual changes to Kubernetes resources can be reverted automatically by ArgoCD.
* Since the application could not be fully deployed due to storage differences between Kind and EKS, complete self-healing validation will be performed on an EKS cluster.

---

# 9. Screenshots

## Screenshot 1

ArgoCD Dashboard

> ![alt text](<WhatsApp Image 2026-06-26 at 4.57.14 PM.jpeg>)

---

## Screenshot 2

Application Resource Tree

> ![alt text](<WhatsApp Image 2026-06-26 at 4.57.14 PM (1).jpeg>)

---

## Screenshot 3

Application Sync Status

> ![alt text](<WhatsApp Image 2026-06-26 at 4.57.14 PM (2).jpeg>)

---

## Screenshot 4

garphana 

> ![alt text](<WhatsApp Image 2026-06-26 at 4.57.13 PM.jpeg>)

---

# 10. Key Learnings

* Learned the GitOps deployment model.
* Understood how ArgoCD continuously reconciles Kubernetes resources.
* Learned the purpose of prune, selfHeal and ServerSideApply.
* Understood why Git should be the single source of truth.
* Learned how ArgoCD detects configuration drift.
* Learned the difference between deploying on Amazon EKS and a local Kind cluster, especially regarding StorageClasses and cloud-specific resources.

---

# Conclusion

Day 84 provided practical exposure to GitOps using ArgoCD. Instead of manually deploying Kubernetes manifests, the deployment process became declarative and Git-driven. Although the complete AI-BankApp deployment could not finish on the local Kind cluster because the project uses AWS EBS (`gp3`) StorageClass, the GitOps workflow, ArgoCD synchronization, and application management concepts were successfully implemented and understood.
