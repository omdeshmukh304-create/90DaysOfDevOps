# Day 57 – Resource Requests, Limits, and Probes

## 📌 Overview

In this lab, we explored how Kubernetes manages resources and ensures application health using resource requests, limits, and probes. These mechanisms help in efficient scheduling, preventing resource overuse, and enabling self-healing systems.

---

## ⚙️ Requests vs Limits

### 🔹 Resource Requests

* Define the **minimum resources** a container needs
* Used by the **scheduler** to place Pods on nodes
* Ensures the Pod gets guaranteed resources

Example:

```yaml
requests:
  cpu: 100m
  memory: 128Mi
```

---

### 🔹 Resource Limits

* Define the **maximum resources** a container can use
* Enforced by the **kubelet at runtime**
* Prevents a container from consuming excessive resources

Example:

```yaml
limits:
  cpu: 250m
  memory: 256Mi
```

---

### 🧠 Key Difference

| Feature  | Requests           | Limits       |
| -------- | ------------------ | ------------ |
| Purpose  | Scheduling         | Enforcement  |
| Used by  | Scheduler          | Kubelet      |
| Behavior | Guarantees minimum | Caps maximum |

---

## 💥 What Happens When Limits Are Exceeded

### 🔸 CPU Limit Exceeded

* CPU is **throttled**
* Container continues running but slower

---

### 🔸 Memory Limit Exceeded

* Container is **terminated immediately**
* Kubernetes reports:

  * `Reason: OOMKilled`
  * `Exit Code: 137`

👉 Memory has no soft limit — it results in a forced kill.

---

## 🔍 Probes in Kubernetes

Probes are used to monitor container health and behavior.

---

### 🔄 Liveness Probe

* Checks if the container is **alive**
* If it fails → container is **restarted**

**Use Case:**

* Detect deadlocks or stuck applications

---

### 🚦 Readiness Probe

* Checks if the container is **ready to serve traffic**
* If it fails:

  * Pod is removed from **Service endpoints**
  * ❌ Container is NOT restarted

**Use Case:**

* Temporary failures, app warming up, dependency issues

---

### 🐢 Startup Probe

* Used for **slow-starting applications**
* Disables liveness and readiness until it succeeds
* Prevents premature restarts

**Use Case:**

* Applications with long initialization time

---

## ⚡ Probe Comparison

| Probe Type | Purpose               | Failure Action           |
| ---------- | --------------------- | ------------------------ |
| Liveness   | Is container alive?   | Restart container        |
| Readiness  | Can it serve traffic? | Remove from Service      |
| Startup    | Has it started yet?   | Restart if startup fails |

---

## 🧠 Summary

* **Requests** help Kubernetes decide where to run Pods
* **Limits** ensure containers don’t exceed resource usage
* **CPU overuse** → throttling
* **Memory overuse** → OOMKilled
* **Liveness probe** → restarts unhealthy containers
* **Readiness probe** → controls traffic flow
* **Startup probe** → protects slow-starting apps

---

## 🚀 Conclusion

These features make Kubernetes applications:

* Efficient (smart scheduling)
* Stable (resource control)
* Reliable (self-healing and traffic management)

---
