# Day 60 – Capstone: Deploy WordPress + MySQL on Kubernetes

## Overview
In this capstone project, I deployed a complete WordPress + MySQL application stack on Kubernetes using the concepts learned throughout the previous days. The deployment included persistent storage, Secrets, ConfigMaps, StatefulSets, Deployments, Services, probes, autoscaling, and Helm comparison.

---

# Architecture

## Components Used

### 1. Namespace
A dedicated namespace called `capstone` was created to isolate all resources related to the project.

### 2. MySQL Database
MySQL was deployed using a StatefulSet because databases require stable identities and persistent storage.

Resources used:
- Secret
- Headless Service
- StatefulSet
- Persistent Volume Claim

### 3. WordPress Application
WordPress was deployed using a Deployment with 2 replicas for high availability.

Resources used:
- ConfigMap
- Deployment
- NodePort Service
- Liveness Probe
- Readiness Probe
- HPA

---

# Resource Connections

```text
User Browser
       |
       v
NodePort Service (WordPress)
       |
       v
WordPress Deployment (2 Pods)
       |
       v
ConfigMap + Secret
       |
       v
MySQL Headless Service
       |
       v
MySQL StatefulSet
       |
       v
Persistent Volume Claim
```

---

# Self-Healing Test Results

## WordPress Pod Recovery
One WordPress pod was deleted manually using:

```bash
kubectl delete pod <wordpress-pod-name> -n capstone
```

Result:
- Kubernetes automatically created a new pod within seconds
- Website remained accessible

## MySQL Pod Recovery
The MySQL pod was deleted using:

```bash
kubectl delete pod mysql-0 -n capstone
```

Result:
- StatefulSet recreated the pod automatically
- Database recovered successfully
- WordPress reconnected after MySQL startup

---

# Persistence Test Result

A sample blog post was created in WordPress before deleting the MySQL pod.

After the pod recreation:
- The blog post was still available
- This verified persistent storage was working correctly

PVC ensured MySQL data survived pod deletion.

---

# HPA Configuration

Horizontal Pod Autoscaler was configured with:
- Minimum replicas: 2
- Maximum replicas: 10
- CPU target utilization: 50%

Verification:

```bash
kubectl get hpa -n capstone
```

---

# Helm Comparison

WordPress was also installed using Helm:

```bash
helm install wp-helm bitnami/wordpress -n helm-wordpress
```

## Comparison

| Manual Kubernetes Setup | Helm Deployment |
|---|---|
| More control | Faster deployment |
| Better learning experience | Easier automation |
| Manual YAML creation | Templates generated automatically |
| Easier to understand architecture | Easier for production reuse |

Helm created many resources automatically, while the manual setup provided deeper understanding of Kubernetes internals.

---

# Concepts Used and Learning Days

| Concept | Day Learned |
|---|---|
| Namespace | Day 52 |
| Deployment | Day 52 |
| Service | Day 53 |
| ConfigMap | Day 54 |
| Secret | Day 54 |
| Persistent Volume Claim | Day 55 |
| StatefulSet | Day 56 |
| Resource Requests & Limits | Day 57 |
| Liveness & Readiness Probes | Day 57 |
| Metrics Server | Day 58 |
| Horizontal Pod Autoscaler | Day 58 |
| Helm | Day 59 |

---

# Reflection

This capstone combined almost every major Kubernetes concept into one real-world application deployment.

The hardest part was:
- debugging Metrics Server issues
- handling WordPress crash loops after MySQL restarts
- understanding StatefulSet networking

The concepts that clicked the most were:
- how Deployments maintain desired state
- how StatefulSets preserve database identity
- how persistent storage works with PVCs
- how Services allow communication between applications

The most interesting part was seeing Kubernetes automatically recover failed pods without manual intervention.

For a production-ready deployment, I would add:
- Ingress Controller
- TLS/HTTPS
- Monitoring with Prometheus and Grafana
- Backup solution for MySQL
- CI/CD pipeline
- Network Policies
- Separate production and staging namespaces

---

# Final Result

Successfully deployed and managed a complete WordPress + MySQL application stack on Kubernetes with:
- persistence
- autoscaling
- self-healing
- resource management
- service discovery
- scaling
- Helm comparison

This project demonstrated how Kubernetes manages real-world containerized applications reliably and automatically.