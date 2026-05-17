# 🚀 Day 59 – Helm (Kubernetes Package Manager)

## 📌 What is Helm?

**Helm** is a package manager for Kubernetes that helps manage complex applications using reusable packages called charts.

Instead of writing multiple YAML files manually, Helm allows you to deploy and manage applications with a single command.

---

## 🧠 Three Core Concepts

### 1. Chart

A **Chart** is a package that contains Kubernetes manifest templates and default configuration.

👉 Example: nginx chart includes Deployment, Service, ConfigMap, etc.

---

### 2. Release

A **Release** is a running instance of a chart in a Kubernetes cluster.

👉 Example: `my-nginx` is a release created from the nginx chart.

---

### 3. Repository

A **Repository** is a collection of Helm charts.

👉 Example: Bitnami repo contains hundreds of production-ready charts.

---

## ⚙️ Installation

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

### Verify:

```bash
helm version
helm env
```

---

## 📦 Deploying a Chart

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm install my-nginx bitnami/nginx
```

👉 This creates Deployment, Service, and other resources automatically.

---

## 🔧 Customization

Helm allows customization using values.

### Using `--set` (quick override)

```bash
helm install my-nginx bitnami/nginx \
  --set replicaCount=3 \
  --set service.type=NodePort
```

---

## 📄 Using Values File

### custom-values.yaml

```yaml
replicaCount: 3

service:
  type: NodePort

resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "200m"
    memory: "256Mi"
```

### Install using file:

```bash
helm install my-nginx bitnami/nginx -f custom-values.yaml
```

---

## 🔄 Upgrade

```bash
helm upgrade my-nginx bitnami/nginx --set replicaCount=5
```

👉 Creates a new revision of the release.

---

## ⏪ Rollback

```bash
helm history my-nginx
helm rollback my-nginx 1
```

👉 Rollback creates a new revision instead of deleting history.

---

## 📂 Helm Chart Structure

When you run:

```bash
helm create my-app
```

You get:

```
my-app/
  Chart.yaml        # Metadata about the chart
  values.yaml       # Default configuration values
  templates/        # Kubernetes manifest templates
```

---

## 🧩 Go Templating in Helm

Helm uses Go templating to make YAML dynamic.

### Example:

```yaml
replicas: {{ .Values.replicaCount }}
```

👉 This pulls values from `values.yaml`.

Other examples:

* `{{ .Chart.Name }}` → chart name
* `{{ .Release.Name }}` → release name

---

## ✅ Validation and Preview

```bash
helm lint my-app
helm template my-release ./my-app
```

---

## 📦 Installing Custom Chart

```bash
helm install my-release ./my-app
```

---

## 🔄 Upgrading Custom Chart

```bash
helm upgrade my-release ./my-app --set replicaCount=5
```

---

## 🎯 Conclusion

Helm simplifies Kubernetes deployments by:

* Reducing YAML complexity
* Enabling reusable configurations
* Supporting versioning, upgrades, and rollbacks

It is an essential tool for managing production-grade Kubernetes applications.
