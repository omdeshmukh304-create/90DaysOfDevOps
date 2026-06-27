# Day 85 - ArgoCD Deep Dive: Sync Strategies, Rollbacks, and Multi-App Management

## 1. Automated vs Manual Sync

### Automated Sync

```yaml
syncPolicy:
  automated:
    prune: true
    selfHeal: true
```

**Features**

* Automatically deploys changes from Git.
* Automatically fixes manual changes in the cluster (Self Heal).
* Deletes resources removed from Git (Prune).
* No manual approval required.

**Best for**

* Development
* Testing
* Staging

---

### Manual Sync

```yaml
syncPolicy: {}
```

**Features**

* Detects changes but does not deploy automatically.
* Requires a user to manually trigger Sync.
* Provides a review gate before deployment.

**Best for**

* Production environments

| Automated Sync        | Manual Sync             |
| --------------------- | ----------------------- |
| Automatic deployment  | Manual deployment       |
| No approval required  | Human approval required |
| Suitable for Dev/Test | Suitable for Production |
| Supports Self Heal    | Detects drift only      |

---

# 2. Sync Waves

Sync Waves control the order in which ArgoCD deploys Kubernetes resources.

| Wave | Resources               | Purpose               |
| ---- | ----------------------- | --------------------- |
| -2   | Namespace, StorageClass | Infrastructure        |
| -1   | PVC, ConfigMap, Secret  | Configuration         |
| 0    | MySQL, Ollama, Services | Database & Networking |
| 1    | BankApp Deployment      | Application           |
| 2    | HPA                     | Auto Scaling          |

Resources in the same wave are deployed in parallel. ArgoCD waits for one wave to become healthy before starting the next.

**Screenshot:** *(Insert ArgoCD Sync Wave screenshot here.)*

---

# 3. ArgoCD Rollback vs Git Revert

### ArgoCD Rollback

* Restores the cluster to a previous deployment.
* Does not modify Git.
* Application becomes OutOfSync.
* Useful for emergency recovery.

### Git Revert

```bash
git revert HEAD
git push
```

* Creates a new commit that reverses previous changes.
* Updates Git (source of truth).
* ArgoCD syncs the reverted commit.
* Correct GitOps approach.

| ArgoCD Rollback    | Git Revert           |
| ------------------ | -------------------- |
| Changes Cluster    | Changes Git          |
| Temporary          | Permanent            |
| OutOfSync          | Synced               |
| Emergency recovery | GitOps best practice |

---

# 4. App of Apps Architecture

The App of Apps pattern uses one parent Application to manage multiple child Applications.

```
Git Repository
│
├── argocd-apps/
│     ├── root-app.yaml
│     ├── bankapp.yaml
│     ├── monitoring.yaml
│     └── envoy-gateway.yaml
│
└── k8s/

        │
        ▼

     Root Application
            │
     ┌──────┼──────────┐
     │      │          │
 BankApp Monitoring Envoy Gateway
```

Benefits:

* Manage multiple applications from one parent application.
* Easy onboarding of new applications.
* Fully GitOps-driven architecture.

**Screenshot:** *(Insert ArgoCD UI showing root-app, bankapp, monitoring, and envoy-gateway.)*

---

# 5. ArgoCD Notifications

Notifications are sent whenever important events occur.

### Triggers

* Sync Succeeded
* Sync Failed
* Health Degraded

### Templates

Example:

```
Application {{.app.metadata.name}} sync succeeded.
Revision: {{.app.status.sync.revision}}
```

### Services

Notifications can be sent using:

* Slack
* Microsoft Teams
* Email
* Discord
* Webhook

Flow:

```
Deployment Event
      │
      ▼
Trigger
      │
      ▼
Template
      │
      ▼
Service
      │
      ▼
Slack / Email / Teams / Webhook
```

---

# 6. Projects and RBAC

## Projects

Projects restrict:

* Allowed Git repositories
* Allowed clusters
* Allowed namespaces

Example:

Project: bankapp-team

Allowed:

* AI-BankApp repository
* bankapp namespace
* monitoring namespace

Not Allowed:

* kube-system
* argocd
* Other repositories

## RBAC

RBAC controls user permissions.

Example:

| Permission | Allowed |
| ---------- | ------- |
| View       | ✔       |
| Sync       | ✔       |
| Rollback   | ✘       |
| Delete     | ✘       |

Projects control **where applications can be deployed**, while RBAC controls **what users are allowed to do**. Together they isolate teams and prevent one team from accidentally modifying another team's application

>Screen Shot

![alt text](<WhatsApp Image 2026-06-27 at 11.29.09 AM.jpeg>)
![alt text](<WhatsApp Image 2026-06-27 at 11.29.09 AM (2).jpeg>)
