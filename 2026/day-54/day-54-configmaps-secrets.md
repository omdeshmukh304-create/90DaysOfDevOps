# 📘 Day 54 – ConfigMaps & Secrets

## 📦 What are ConfigMaps and Secrets?

### 🔹 ConfigMaps

ConfigMaps are used to store **non-sensitive configuration data** in key-value pairs. This can include:

- Application settings  
- Environment configurations  
- Config files  

#### 👉 Use ConfigMaps when:
- Data is not confidential  
- You want to separate configuration from code  
- You need dynamic configuration updates  

---

### 🔐 Secrets

Secrets are used to store **sensitive data**, such as:

- Passwords  
- API keys  
- Database credentials  
- Tokens  

#### 👉 Use Secrets when:
- Data is confidential  
- You want to avoid exposing sensitive information in plain text  
- You need secure handling of credentials inside Kubernetes  

---

## ⚖️ Difference Between ConfigMaps and Secrets

| Feature    | ConfigMap        | Secret              |
|------------|------------------|---------------------|
| Data Type  | Non-sensitive    | Sensitive           |
| Storage    | Plain text       | Base64 encoded      |
| Use Case   | App configs      | Passwords, keys     |
| Security   | Not secure       | Slightly more secure|

---

## 🔄 Environment Variables vs Volume Mounts

### 🌱 Environment Variables

- Inject values directly into container environment  
- Accessed using standard environment variable syntax  

```bash
echo $MY_VAR

## ❌ Disadvantages

- Do not update automatically when ConfigMap or Secret changes  
- Requires pod restart to reflect changes  

---

## 📁 Volume Mounts

- ConfigMap or Secret is mounted as files inside the container  
- Each key becomes a file  



## 🔐 Why Base64 is Encoding, Not Encryption

Kubernetes stores Secrets in Base64 encoded format, but:

- Base64 is not encryption  
- It is just a way to convert data into readable ASCII format  
- Anyone can easily decode it  

```bash
echo "dmFsdWU=" | base64 --decode



## ⚠️ Important

- Base64 does not provide security  
- It only ensures data can be safely transmitted or stored  

---

## 🔄 ConfigMap Update Behavior

### 📁 Volume Mounts

When a ConfigMap is updated:

- Changes are automatically reflected inside the container  
- No restart needed  
- Update delay: approximately 30–60 seconds  

---

### 🌱 Environment Variables

When a ConfigMap is updated:

- Changes are not reflected  
- Pod must be restarted to get new values  

---

## 🧾 Summary

- Use ConfigMaps for non-sensitive configuration  
- Use Secrets for sensitive data  
- Use Volume Mounts for dynamic updates  
- Use Environment Variables for simple, static configurations  

---

## 🔁 ConfigMap Updates

- ✅ Auto-update in volumes  
- ❌ Do not update in environment variables  

---

## 🔐 Security Note

- Base64 is just encoding, not security  