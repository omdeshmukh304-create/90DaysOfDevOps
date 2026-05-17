# Day 56 – Kubernetes StatefulSets

## 📌 Introduction

In Kubernetes, **StatefulSets** are used to manage **stateful applications** such as databases (MySQL, PostgreSQL, MongoDB).

Unlike Deployments, StatefulSets provide:

* Stable pod identity
* Ordered deployment and scaling
* Persistent storage per pod

---

## 📌 When to Use StatefulSets vs Deployments

### 🔹 Use Deployment when:

* Application is **stateless**
* Pods can be replaced freely
* No need for fixed identity
* Example: Nginx, frontend apps

### 🔹 Use StatefulSet when:

* Application is **stateful**
* Needs **stable identity**
* Requires **persistent storage**
* Requires **ordered startup/shutdown**
* Example: Databases, Kafka, Zookeeper

---

## 📊 Comparison Table

| Feature          | Deployment        | StatefulSet               |
| ---------------- | ----------------- | ------------------------- |
| Pod names        | Random            | Stable (`web-0`, `web-1`) |
| Startup order    | Parallel          | Ordered                   |
| Storage          | Shared / optional | Dedicated per pod         |
| Network identity | Not stable        | Stable DNS                |
| Scaling          | Random            | Ordered                   |

---

## 📌 Headless Service

A **Headless Service** is created by setting:

```yaml
clusterIP: None
```

### 🔹 Purpose:

* Does **not assign a cluster IP**
* Creates **individual DNS entries for each pod**
* Required for StatefulSets

### 🔹 Example DNS:

```
web-0.nginx-headless.default.svc.cluster.local
web-1.nginx-headless.default.svc.cluster.local
```

---

## 📌 Stable DNS

Each pod in StatefulSet gets a **fixed DNS name**:

```
<pod-name>.<service-name>.<namespace>.svc.cluster.local
```

### 🔹 Example:

```
web-0.nginx-headless.default.svc.cluster.local
```

### 🔹 Benefit:

* Pods can communicate reliably
* Required for clustering (DB replication)

---

## 📌 volumeClaimTemplates

StatefulSets use **volumeClaimTemplates** to create storage for each pod.

### 🔹 Example:

```yaml
volumeClaimTemplates:
- metadata:
    name: web-data
  spec:
    accessModes: ["ReadWriteOnce"]
    resources:
      requests:
        storage: 100Mi
```

### 🔹 Result:

Each pod gets its own PVC:

```
web-data-web-0
web-data-web-1
web-data-web-2
```

### 🔹 Key Feature:

* Storage is **persistent**
* Even if pod is deleted, data remains

---


## 📌 Conclusion

StatefulSets are essential for applications that require:

* Stable identity
* Persistent storage
* Reliable networking

They solve the limitations of Deployments for stateful workloads like databases.

---

## ✅ Key Learnings

* Deployment is for **stateless apps**
* StatefulSet is for **stateful apps**
* Headless Service enables **pod-level DNS**
* volumeClaimTemplates provide **persistent storage**
* Pods maintain **identity even after restart**

---
