# Day 51 – Kubernetes Pods

---

## 1. Four Required Fields of a Kubernetes Manifest

Every Kubernetes manifest must contain these core fields:

### 1. apiVersion

* Defines which version of Kubernetes API you are using
* Example: `v1`

### 2. kind

* Specifies the type of resource
* Example: `Pod`, `Service`, `Deployment`

### 3. metadata

* Contains information like:

  * name of the resource
  * labels (used for grouping/filtering)

### 4. spec

* Defines the actual configuration of the resource
* Example:

  * containers
  * images
  * ports

---

## 2. Pod Manifests

### nginx-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
    - name: nginx
      image: nginx:latest
      ports:
        - containerPort: 80
```

---

### busybox-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-pod
  labels:
    app: busybox
spec:
  containers:
    - name: busybox
      image: busybox
      command: ["sleep", "3600"]
```

---

### multi-label-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-label-pod
  labels:
    app: myapp
    environment: dev
    team: backend
spec:
  containers:
    - name: nginx
      image: nginx:latest
      ports:
        - containerPort: 80
```

---

## 3. Imperative vs Declarative

### Imperative (kubectl run)

* Commands directly create resources
* Example:

```bash
kubectl run nginx-pod --image=nginx
```

* Quick and easy
* Not used in production

---

### Declarative (kubectl apply -f)

* Uses YAML files
* Example:

```bash
kubectl apply -f nginx-pod.yaml
```

* Preferred approach
* Version-controlled and reproducible

---

## 4. Screenshot of Pods Running

Run:

```bash
kubectl get pods
```

Expected output:

```
NAME               READY   STATUS    
nginx-pod          1/1     Running   
busybox-pod        1/1     Running   
multi-label-pod    1/1     Running   
```

(*Add your actual screenshot here*)

---

## 5. What Happens When You Delete a Standalone Pod?

* The Pod is permanently deleted
* It is NOT recreated automatically
* There is no controller managing it

👉 This is why standalone Pods are not used in production

Instead, Kubernetes uses:

* Deployments (self-healing)
* ReplicaSets

---

## Summary

* Learned how to create Pods using YAML
* Understood manifest structure
* Practiced labels and filtering
* Compared imperative vs declarative approaches
* Learned why Deployments are needed

---
