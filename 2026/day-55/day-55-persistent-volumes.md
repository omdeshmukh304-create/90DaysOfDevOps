# 📘 Day 55 – Persistent Volumes (PV) and Persistent Volume Claims (PVC)

---

## 🔴 Why Containers Need Persistent Storage

Containers in Kubernetes are **ephemeral** by nature.

This means:

* When a Pod is deleted → all data inside it is lost
* When a container restarts → filesystem resets

This creates a serious problem for:

* Databases (MySQL, MongoDB)
* Logs
* User uploads
* Any stateful application

To solve this, Kubernetes provides **persistent storage**, which exists **independently of the Pod lifecycle**.

---

## 🟢 What are PVs and PVCs?

### 📦 Persistent Volume (PV)

A **Persistent Volume (PV)** is a piece of storage in the cluster.

* It is created and managed by the cluster (or admin)
* It represents actual storage (disk, cloud volume, or node path)
* It exists independently of Pods

Example:

* AWS EBS volume
* Azure Disk
* Local node directory (`hostPath`)

---

### 📄 Persistent Volume Claim (PVC)

A **Persistent Volume Claim (PVC)** is a request for storage.

* Created by developers
* Specifies required storage size and access mode
* Kubernetes finds and binds a matching PV

---

### 🔗 Relationship Between PV and PVC

The binding process works like this:

```plaintext
Pod → PVC → PV → Physical Storage
```

* Pod uses PVC
* PVC connects to PV
* PV provides actual storage

Once bound:

* The PVC is permanently linked to a PV
* The Pod can read/write data through it

---

## 🔄 Static vs Dynamic Provisioning

### 🧱 Static Provisioning

In static provisioning:

* Administrator manually creates PVs
* Developer creates PVC to claim existing PV

Flow:

```plaintext
PV (created manually) → PVC → Pod
```

**Pros:**

* Full control over storage

**Cons:**

* Manual effort
* Not scalable

---

### ⚡ Dynamic Provisioning

In dynamic provisioning:

* Developer only creates PVC
* Kubernetes automatically creates PV using a **StorageClass**

Flow:

```plaintext
PVC → StorageClass → Auto-created PV → Pod
```

**Pros:**

* Fully automated
* Scalable
* Used in real-world production

---

## 🔐 Access Modes

Access modes define how a volume can be mounted:

| Access Mode         | Meaning                      |
| ------------------- | ---------------------------- |
| ReadWriteOnce (RWO) | Read-write by a single node  |
| ReadOnlyMany (ROX)  | Read-only by multiple nodes  |
| ReadWriteMany (RWX) | Read-write by multiple nodes |

---

## ♻️ Reclaim Policies

Reclaim policy defines what happens when a PVC is deleted:

| Policy  | Behavior                             |
| ------- | ------------------------------------ |
| Retain  | Keeps data (manual cleanup required) |
| Delete  | Deletes the storage automatically    |
| Recycle | (Deprecated)                         |

---

## 🎯 Key Takeaways

* Containers are ephemeral → data is lost without persistent storage
* PV = actual storage, PVC = request for storage
* Pod never directly uses PV — it uses PVC
* Static provisioning = manual PV creation
* Dynamic provisioning = automatic PV creation using StorageClass
* Access modes control how storage is used
* Reclaim policies define data lifecycle

---

## 🚀 Conclusion

Persistent Volumes and Persistent Volume Claims allow Kubernetes to handle **stateful applications** effectively by separating storage from container lifecycle. This ensures that data remains safe even if Pods are deleted or recreated.

---
