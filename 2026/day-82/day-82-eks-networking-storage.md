# Day 82 – EKS Networking with Gateway API and Persistent Storage

## Objective

Learn how the AI-BankApp uses the Kubernetes Gateway API, Envoy Gateway, cert-manager, AWS EBS storage, and HPA on Amazon EKS.

---

# Gateway API Architecture

```text
                         Internet
                             │
                             ▼
               AWS Network Load Balancer (NLB)
                             │
                             ▼
                  Gateway (bankapp-gateway)
                  HTTP (80) | HTTPS (443)
                             │
                             ▼
                 HTTPRoute (bankapp-route)
                             │
                             ▼
                  Service (bankapp-service)
                             │
                ┌────────────┴────────────┐
                ▼                         ▼
          BankApp Pod 1            BankApp Pod 2
                ▲                         ▲
                └──── BANKAPP_AFFINITY ──┘
                        (Cookie)
                             │
             ┌───────────────┴───────────────┐
             ▼                               ▼
        MySQL Pod                      Ollama Pod
             │                               │
         PVC (5Gi)                      PVC (10Gi)
             │                               │
         AWS EBS Volume                 AWS EBS Volume
```

---

# Gateway API vs Ingress

| Feature | Ingress | Gateway API |
|----------|----------|-------------|
| API | Older | Modern |
| Traffic Routing | Basic | Advanced |
| Traffic Split | Limited | Native |
| TLS | Annotation-based | Native |
| Session Affinity | Controller specific | BackendTrafficPolicy |
| Used in AI-BankApp | ❌ | ✅ |

---

# Gateway API Resources

## GatewayClass

- Selects the Gateway controller.
- AI-BankApp uses Envoy Gateway.

## Gateway

- Creates the application's entry point.
- Opens HTTP (80) and HTTPS (443).
- Terminates TLS connections.

## HTTPRoute

- Routes incoming traffic to the bankapp-service.

## BackendTrafficPolicy

- Enables cookie-based session affinity.
- Uses the BANKAPP_AFFINITY cookie.
- Ensures users always connect to the same pod after login.

---

# Why Cookie-Based Session Affinity?

The AI-BankApp uses Spring Security with session-based authentication.

Without session affinity:

Request 1 → Pod 1

Request 2 → Pod 2

The second pod doesn't know the user's login session, so the user may be logged out.

With BackendTrafficPolicy:

User → Cookie → Same Pod

This keeps the user's session active.

---

# cert-manager and HTTPS

Flow:

Browser

↓

Gateway

↓

cert-manager

↓

Let's Encrypt

↓

HTTP-01 Challenge

↓

Certificate Issued

↓

bankapp-tls Secret

↓

HTTPS Enabled

Steps:

1. cert-manager requests a certificate from Let's Encrypt.
2. Let's Encrypt sends an HTTP-01 challenge.
3. cert-manager creates a temporary HTTPRoute.
4. Domain ownership is verified.
5. The certificate is stored in the bankapp-tls Secret.
6. Gateway uses the Secret to terminate HTTPS.

---

# EBS Persistent Storage

Storage Flow

Application Pod

↓

Persistent Volume Claim (PVC)

↓

Persistent Volume (PV)

↓

AWS EBS Volume

MySQL uses a 5Gi gp3 EBS volume.

Ollama uses a 10Gi gp3 EBS volume.

Data remains safe even if the Pod is deleted because EBS exists independently of the Pod.

---

# Resource Budget

| Component | CPU | Memory | Instances |
|-----------|-----|--------|-----------|
| BankApp | 250m | 256Mi | 2–4 Pods |
| MySQL | 250m | 256Mi | 1 |
| Ollama | 900m | 2Gi | 1 |
| Init Containers | 50m | 32Mi | Temporary |
| System Pods | ~500m | ~500Mi | Per Node |
| Total (3×t3.medium) | 6000m | 12Gi | |

---

# Expected Verification Commands

```bash
kubectl get gateway -n bankapp

kubectl get pvc -n bankapp

kubectl top nodes

kubectl top pods -n bankapp
```

---

# Screenshots

## Gateway

```bash
kubectl get gateway -n bankapp
```

![alt text](<WhatsApp Image 2026-06-26 at 11.42.11 AM.jpeg>)

## PVC

```bash
kubectl get pvc -n bankapp
```
![alt text](<WhatsApp Image 2026-06-26 at 11.42.10 AM.jpeg>)

---

# Key Learnings

- Gateway API is the modern replacement for Ingress.
- Envoy Gateway implements Gateway API.
- Gateway receives external traffic.
- HTTPRoute forwards traffic to Services.
- BackendTrafficPolicy enables session persistence using cookies.
- cert-manager automates TLS certificate management.
- AWS EBS provides persistent storage for MySQL and Ollama.
- HPA automatically scales BankApp pods based on CPU utilization.