# Day 80 - Helm Environments, Hooks and Chart Packaging

## Introduction

On Day 80, I focused on making the AI-BankApp Helm chart production-ready by introducing environment-specific configurations, learning Helm Hooks, packaging the chart for distribution, and understanding how Helm integrates with GitOps workflows.

In real-world deployments, applications run across multiple environments such as Development, Staging, and Production. Maintaining separate Kubernetes manifests for each environment leads to duplication and increased maintenance overhead. Helm solves this problem by allowing a single chart to be reused with different configuration values.

---

## Objectives

* Create environment-specific deployments using Helm values files
* Deploy the same chart to Dev, Staging, and Production environments
* Learn Helm Hooks and their practical use cases
* Package Helm charts for distribution
* Understand Helm upgrade and rollback operations
* Explore Helm's role in GitOps workflows

---

## Project Structure

```text
helm-chart/
└── bankapp/
    ├── Chart.yaml
    ├── values.yaml
    ├── values-dev.yaml
    ├── values-staging.yaml
    ├── values-prod.yaml
    └── templates/
```

---

## Environment-Specific Configurations

Instead of creating separate Kubernetes manifests for every environment, Helm uses different values files while keeping the templates unchanged.

### Development Environment

```yaml
replicaCount: 1

resources:
  requests:
    cpu: 100m
    memory: 256Mi
```

Deployment Command:

```bash
helm install bankapp-dev bankapp/ \
-n dev \
-f values-dev.yaml
```

---

### Staging Environment

```yaml
replicaCount: 2

resources:
  requests:
    cpu: 250m
    memory: 512Mi
```

Deployment Command:

```bash
helm install bankapp-staging bankapp/ \
-n staging \
-f values-staging.yaml
```

---

### Production Environment

```yaml
replicaCount: 3

resources:
  requests:
    cpu: 500m
    memory: 1Gi
```

Deployment Command:

```bash
helm install bankapp-prod bankapp/ \
-n prod \
-f values-prod.yaml
```

---

## Benefits of Environment-Specific Values

Using separate values files provides several advantages:

* Eliminates YAML duplication
* Simplifies maintenance
* Keeps deployments consistent
* Makes environment creation faster
* Allows configuration changes without modifying templates

The same Helm chart can now be deployed across multiple environments by changing only the values file.

---

## Helm Hooks

Helm Hooks allow Kubernetes resources to execute at specific points during a release lifecycle.

Example:

```yaml
metadata:
  annotations:
    "helm.sh/hook": pre-install
```

Common Hook Types:

| Hook         | Description                      |
| ------------ | -------------------------------- |
| pre-install  | Executes before installation     |
| post-install | Executes after installation      |
| pre-upgrade  | Executes before upgrade          |
| post-upgrade | Executes after upgrade           |
| pre-delete   | Executes before release deletion |

Example Job:

```yaml
apiVersion: batch/v1
kind: Job

metadata:
  name: db-init
  annotations:
    "helm.sh/hook": pre-install
```

This job runs before the application installation begins and can be used for database initialization or validation tasks.

---

## Chart Validation

Before deployment, Helm charts should be validated.

Lint the chart:

```bash
helm lint bankapp/
```

Purpose:

* Detect syntax errors
* Validate chart structure
* Verify template rendering logic

---

## Template Rendering

Generate Kubernetes manifests without deploying:

```bash
helm template my-bankapp bankapp/
```

Purpose:

* Preview generated manifests
* Debug templates
* Verify values substitution

This command renders all Kubernetes resources locally without creating them in the cluster.

---

## Packaging the Helm Chart

Once validated, the chart can be packaged into a distributable artifact.

Package the chart:

```bash
helm package bankapp/
```

Output:

```text
bankapp-0.1.0.tgz
```

Install packaged chart:

```bash
helm install bankapp bankapp-0.1.0.tgz
```

Packaging allows charts to be shared, versioned, and stored in chart repositories.

---

## Helm Release Management

### Upgrade a Release

```bash
helm upgrade bankapp bankapp/ \
-n prod \
-f values-prod.yaml
```

### List Releases

```bash
helm list -A
```

### View Release History

```bash
helm history bankapp
```

### Rollback a Release

```bash
helm rollback bankapp 1
```

Helm stores release history, making upgrades and rollbacks simple and reliable.

---

## Helm in GitOps

Helm plays a significant role in GitOps workflows.

Typical Flow:

```text
Developer
    ↓
Git Push
    ↓
Git Repository
    ↓
ArgoCD / Flux
    ↓
Helm Chart
    ↓
Kubernetes Cluster
```

Workflow:

1. Developer updates chart templates or values files.
2. Changes are committed and pushed to Git.
3. ArgoCD or Flux detects repository changes.
4. Helm renders Kubernetes manifests.
5. Kubernetes applies the updated resources.
6. Cluster state automatically matches Git.

This approach ensures consistency, traceability, and automated deployments.

---

## Key Learnings

* One Helm chart can support multiple environments.
* Values files enable environment-specific customization.
* Helm Hooks automate lifecycle operations.
* Helm packaging creates reusable deployment artifacts.
* Helm upgrades and rollbacks simplify release management.
* Helm integrates naturally with GitOps platforms such as ArgoCD and Flux.

---

## Commands Used

```bash
helm lint bankapp/

helm template my-bankapp bankapp/

helm install bankapp-dev bankapp/ -n dev -f values-dev.yaml

helm install bankapp-staging bankapp/ -n staging -f values-staging.yaml

helm install bankapp-prod bankapp/ -n prod -f values-prod.yaml

helm package bankapp/

helm list -A

helm history bankapp

helm rollback bankapp 1
```

---

## Conclusion

Day 80 focused on transforming the AI-BankApp Helm chart into a reusable deployment package capable of supporting Development, Staging, and Production environments. By leveraging environment-specific values files, Helm Hooks, chart packaging, and release management capabilities, the deployment process became more scalable, maintainable, and production-ready. This knowledge also established the foundation for integrating Helm with GitOps tools such as ArgoCD and Flux for automated Kubernetes deployments.
