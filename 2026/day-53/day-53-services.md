# 📄 Day 53 – Kubernetes Services

## Why Services?

In Kubernetes, every Pod is assigned its own IP address. However, directly using Pod IPs is not practical due to some important limitations.

### Problems with Pod IPs

1. **Pod IPs are not stable**  
   Pods are temporary in nature. When a Pod restarts, crashes, or gets replaced, it gets a new IP address. This makes direct communication unreliable.

2. **Multiple Pods in a Deployment**  
   A Deployment runs multiple replicas of a Pod. Each Pod has a different IP address, so a client cannot decide which Pod to connect to.

---

### Solution: Kubernetes Service

A **Service** provides a stable way to access a group of Pods.

It offers:

- A **stable IP address (ClusterIP)** that does not change
- A **DNS name** for easy access within the cluster
- **Load balancing** across all matching Pods
- **Loose coupling** between clients and Pods

---

### How It Works

A Service uses **labels and selectors** to identify Pods. Instead of connecting directly to Pods, the client connects to the Service, which forwards traffic to one of the Pods.



---

## 🧩 What Problem Services Solve

In Kubernetes, Pods are **temporary (ephemeral)**:
- Pods can restart or be recreated
- Their IP addresses change frequently
- Direct communication using Pod IPs is unreliable

👉 This creates a major problem:
**How can applications communicate reliably if Pod IPs keep changing?**

---

## ✅ Solution: Kubernetes Service

A **Service** provides a stable way to access Pods.

It offers:
- Stable IP address
- Stable DNS name
- Load balancing across multiple Pods

---

## 🔗 Relationship with Pods and Deployments




- **Deployment** ensures the desired number of Pods are running
- **Service** provides stable access to those Pods

---


