# Day 52 – Kubernetes Namespaces and Deployments

## 📌 What are Namespaces?

Namespaces in Kubernetes are used to **logically separate resources** within a cluster. They allow multiple environments (like dev, staging, production) to exist inside the same cluster without interfering with each other.

### ✅ Why use Namespaces?

* Environment separation (dev, staging, prod)
* Resource organization
* Access control (RBAC)
* Avoid naming conflicts

### 🧠 Example:

* `dev` → for development testing
* `staging` → for pre-production testing
* `production` → live environment

---

## 📄 Deployment Manifest

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        ports:
        - containerPort: 80
```

---

## 🔍 Explanation of Each Section

* **apiVersion: apps/v1**
  Specifies the API version for Deployment resources.

* **kind: Deployment**
  Defines that this resource is a Deployment.

* **metadata**
  Contains name, namespace, and labels for identification.

* **spec.replicas: 3**
  Ensures 3 identical Pods are always running.

* **selector.matchLabels**
  Connects Deployment with the Pods it manages.

* **template**
  Blueprint used to create Pods.

* **containers**
  Defines container details like image and port.

---

## ⚖️ Deployment vs Standalone Pod

### 🔴 Standalone Pod

* If deleted → **gone forever**
* No controller to recreate it

### 🟢 Deployment Pod

* If deleted → **automatically recreated**
* Managed by Deployment controller
* Ensures desired state (e.g., always 3 pods)

### ✅ Conclusion:

Deployment provides **self-healing**, standalone Pods do not.

---

## 📈 Scaling in Kubernetes

### 🔹 Imperative Scaling (CLI)

```bash
kubectl scale deployment nginx-deployment --replicas=5 -n dev
```

* Directly changes number of running Pods
* Fast and temporary method

---

### 🔹 Declarative Scaling (YAML)

Update in manifest:

```yaml
replicas: 5
```

Then apply:

```bash
kubectl apply -f nginx-deployment.yaml
```

* Preferred method
* Maintains desired state via configuration

---

## 🔄 Rolling Updates

### 🔹 Update Image

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.25 -n dev
```

### 🔹 What Happens?

* Pods are updated **one by one**
* New pod is created before old one is deleted
* Ensures **zero downtime**

---

## 🔙 Rollback

### 🔹 Rollback Command

```bash
kubectl rollout undo deployment/nginx-deployment -n dev
```

### 🔹 Result

* Deployment returns to **previous version**
* Example: `nginx:1.25 → nginx:1.24`

---



### 🖼️ Deployment

```
kubectl get deployments -n dev
```

### 🖼️ Pods

```
kubectl get pods -n dev
kubectl get pods -A
```

*(Attach your actual screenshots here)*

---

## 🧠 Key Takeaways

* Namespaces help organize and isolate resources
* Deployments manage Pods and ensure availability
* Scaling adjusts number of replicas dynamically
* Rolling updates ensure zero downtime
* Rollbacks restore previous working versions

---

## 🚀 Conclusion

Today, I learned how to manage applications in Kubernetes using Deployments and Namespaces. I explored self-healing, scaling, and rolling updates, which are essential for running reliable and scalable systems in production.

---
