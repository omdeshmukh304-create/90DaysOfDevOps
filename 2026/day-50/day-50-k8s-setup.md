# 📘 Day 50 – Kubernetes Architecture & Cluster Setup

##  Challenge Task 1: Recall the Kubernetes Story

---

###  1. Why was Kubernetes created?

Kubernetes was created to solve the problem of **managing containers at scale**.

While Docker is great for:
- Creating containers
- Running containers on a single machine

It becomes difficult when:
- You have **hundreds of containers**
- Running across **multiple servers**
- Need **auto-scaling**, **load balancing**, and **self-healing**

 Kubernetes helps by:
- Automatically deploying containers
- Scaling apps up/down based on demand
- Restarting failed containers (self-healing)
- Managing networking between containers

---

###  2. Who created Kubernetes and what was it inspired by?

- Kubernetes was originally created by **:contentReference[oaicite:0]{index=0}**
- It was inspired by Google's internal system called **Borg**

 Google had years of experience running containers at massive scale, and Kubernetes is built using those learnings.

Later:
- Kubernetes was donated to the **Cloud Native Computing Foundation (CNCF)**

---

###  3. What does "Kubernetes" mean?

- The word **Kubernetes** comes from **Greek**
- It means **"Helmsman"** or **"Ship Captain"**

Meaning:
Just like a ship captain manages a ship,
Kubernetes manages containers

---

##  Quick Summary

- Docker → Runs containers  
- Kubernetes → Manages containers at scale  

- Created by → Google  
- Inspired by → Borg  
- Meaning → Ship Captain (Container Manager)

---

##  Note

This is based on **recall from learning session**.  
Next step  Verify with official Kubernetes documentation.

---


# Day 50 – Kubernetes Architecture (From Memory)

## Challenge Task 2: Kubernetes Architecture

---

## Kubernetes Architecture (Clean Diagram)



![alt text](<Kubernetes architecture diagram in ASCII-1.png>)




---

## Control Plane (Master Node)

### API Server
- Acts as the entry point to the cluster
- All commands from `kubectl` go through it
- Validates and processes requests

### etcd
- Key-value store database
- Stores entire cluster state (pods, nodes, configs)

### Scheduler
- Selects the best worker node for new pods
- Based on resources and constraints

### Controller Manager
- Continuously checks cluster state
- Ensures desired state matches actual state

---

## Worker Node

### kubelet
- Agent running on each node
- Communicates with API server
- Ensures containers are running as expected

### kube-proxy
- Manages networking rules
- Enables communication between pods and services

### Container Runtime
- Executes containers
- Examples: containerd, CRI-O

---

## Request Flow: `kubectl apply -f pod.yaml`

1. User runs command using `kubectl`
2. Request goes to API Server
3. API Server:
   - Validates request
   - Stores desired state in etcd
4. Scheduler selects a worker node
5. API Server updates selected node
6. kubelet on that node:
   - Pulls container image
   - Starts container using runtime
7. Pod is created and starts running

---

## Failure Scenarios

### If API Server Goes Down
- No new commands can be executed
- Cluster cannot be modified
- Existing pods continue running

---

### If Worker Node Goes Down
- Pods on that node stop
- Controller Manager detects failure
- Scheduler creates replacement pods on other nodes

---

## Summary

- Control Plane manages the cluster
- Worker Nodes run applications
- API Server is the central communication point
- etcd stores state
- Scheduler assigns work
- kubelet executes tasks on nodes

---


## Task 3: Install kubectl

`kubectl` is the command-line tool used to interact with a Kubernetes cluster.

---

### Installation

#### macOS
```bash
brew install kubectl


curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/


choco install kubernetes-cli

kubectl version --client

```

---


## Task 4: Set Up Your Local Cluster

Choose one tool to create a local Kubernetes cluster.

---

### Option A: kind (Kubernetes in Docker)

```bash
# Install kind

# macOS
brew install kind

# Linux
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Create cluster
kind create cluster --name devops-cluster

# Verify
kubectl cluster-info
kubectl get nodes

```

## Task 5: Explore Your Cluster

Now that the cluster is running, use `kubectl` to explore its components.

---

### Basic Exploration Commands

```bash
# Cluster info
kubectl cluster-info

# List nodes
kubectl get nodes

# Detailed node info
kubectl describe node <node-name>

# List namespaces
kubectl get namespaces

# All pods across all namespaces
kubectl get pods -A
```

## Task 6: Practice Cluster Lifecycle

---

### Cluster Lifecycle Commands

```bash
# Delete cluster (kind)
kind delete cluster --name devops-cluster

# Recreate cluster
kind create cluster --name devops-cluster

# Verify
kubectl get nodes




# Current cluster context
kubectl config current-context

# List all contexts
kubectl config get-contexts

# View full configuration
kubectl config view



## What is kubeconfig?

`kubeconfig` is a configuration file that tells `kubectl`:

- Which cluster to connect to  
- How to authenticate with the cluster  
- Which user and context to use  

It acts like a **connection profile for Kubernetes clusters**.

---

## What does it contain?

- **Clusters** → API server endpoints  
- **Users** → Credentials (certificates, tokens)  
- **Contexts** → Mapping of cluster + user + namespace  