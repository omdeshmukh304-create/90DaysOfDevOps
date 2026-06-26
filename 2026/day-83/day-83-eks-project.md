# Day 83 - EKS Project: Production Deployment of AI-BankApp

## Objective

Deploy the complete AI-BankApp on Amazon EKS with a production-style architecture including:

* Spring Boot AI-BankApp
* MySQL Database
* Ollama AI Service
* Gateway API (Envoy Gateway)
* Persistent Storage (Amazon EBS)
* Horizontal Pod Autoscaler (HPA)
* Prometheus & Grafana Monitoring

---

# Architecture

```text
                     Internet
                         │
                         ▼
            AWS Network Load Balancer (NLB)
                         │
                         ▼
                Envoy Gateway (Gateway API)
                         │
                         ▼
                 AI-BankApp Service
                         │
          ┌──────────────┴──────────────┐
          ▼                             ▼
   Spring Boot Pods               Horizontal Pod Autoscaler
          │
          ├──────────────┐
          ▼              ▼
      MySQL Pod      Ollama Pod
          │              │
          ▼              ▼
      Amazon EBS     Amazon EBS

                 Amazon EKS Cluster
                        │
                  Worker Node Group
                        │
                         VPC
```

---

# Deployment Steps

## 1. Verify EKS Cluster

```bash
kubectl get nodes
```

---

## 2. Deploy AI-BankApp Stack

* Namespace
* Persistent Volume
* Persistent Volume Claim
* ConfigMap
* Secrets
* MySQL
* Ollama
* BankApp
* Horizontal Pod Autoscaler

---

## 3. Configure Gateway API

* Install Envoy Gateway
* Apply Gateway configuration
* Wait for AWS Network Load Balancer
* Obtain External URL

---

## 4. Access Application

* Open AI-BankApp in browser
* Register new user
* Login
* Deposit money
* Withdraw money
* Transfer funds
* Test AI Chatbot
* Verify Dark/Light Mode

---

## 5. Deploy Monitoring

Installed:

* Prometheus
* Grafana
* kube-prometheus-stack

Created:

* ServiceMonitor

Collected Metrics:

* JVM Metrics
* HTTP Request Metrics  
* Kubernetes Metrics

---

# PromQL Queries

### JVM Memory Usage

```promql
jvm_memory_used_bytes{namespace="bankapp"}
```

### HTTP Request Rate

```promql
rate(http_server_requests_seconds_count{namespace="bankapp"}[5m])
```

### HTTP Request Latency (95%)

```promql
histogram_quantile(
0.95,
rate(http_server_requests_seconds_bucket{namespace="bankapp"}[5m])
)
```

---

# Validation Checklist

| Component             | Status |
| --------------------- | ------ |
| EKS Cluster           | ✅      |
| Worker Nodes          | ✅      |
| BankApp Pods          | ✅      |
| MySQL                 | ✅      |
| Ollama                | ✅      |
| PVC Bound             | ✅      |
| Gateway               | ✅      |
| Network Load Balancer | ✅      |
| HPA                   | ✅      |
| Prometheus            | ✅      |
| Grafana               | ✅      |
| AI Chatbot            | ✅      |

---

# Screenshots

Add the following screenshots:

* AI-BankApp Dashboard
* AI Chatbot
* `kubectl get all -n bankapp`
* Grafana Dashboard
* Prometheus Targets

---

# Teardown Procedure

1. Delete Monitoring Stack
2. Delete Gateway Resources
3. Delete AI-BankApp Resources
4. Delete Namespaces
5. Run:

```bash
terraform destroy
```

6. Verify AWS Console

* No EKS Cluster
* No EC2 Instances
* No Load Balancer
* No EBS Volumes
* No VPC

---

# Key Takeaways

* Provisioned EKS using Terraform
* Deployed AI-BankApp on Kubernetes
* Used Gateway API with Envoy Gateway
* Configured Persistent Storage using Amazon EBS
* Implemented Horizontal Pod Autoscaling
* Monitored the application using Prometheus and Grafana
* Performed complete end-to-end validation
* Destroyed all AWS resources to avoid unnecessary costs

---

# Cost Report

| Resource              | Approximate Cost         |
| --------------------- | ------------------------ |
| Amazon EKS            | Included                 |
| EC2 Worker Nodes      | Included                 |
| NAT Gateway           | Included                 |
| EBS Volumes           | Included                 |
| Network Load Balancer | Included                 |
| Total Lab Cost        | **Approximately $15–25** |

---

# Conclusion

Successfully deployed the AI-BankApp on Amazon EKS with a production-ready architecture including persistent storage, Gateway API, monitoring, autoscaling, and complete validation. Finally, all AWS resources were cleaned up using Terraform to prevent additional charges.
