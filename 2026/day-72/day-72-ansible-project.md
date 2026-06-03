# Day 72 - Ansible Capstone Project: Docker + Nginx Reverse Proxy + Vault

## Objective

Deploy a containerized application on AWS EC2 using Ansible Roles, Docker, Nginx Reverse Proxy, Templates, and Vault.

---

# Architecture

```text
Ansible Control Node
        |
        v
AWS EC2 Server
        |
        +--> Nginx (Port 80)
                |
                v
        Docker Container (Port 8080)
                |
                v
          nginx:latest
```

---

# Project Directory Structure

```text
ansible-docker-project/
├── ansible.cfg
├── inventory.ini
├── site.yml
├── group_vars/
│   └── web/
│       ├── vars.yml
│       └── vault.yml
├── roles/
│   ├── common/
│   │   ├── defaults/
│   │   ├── handlers/
│   │   ├── tasks/
│   │   ├── templates/
│   │   └── vars/
│   │
│   ├── docker/
│   │   ├── defaults/
│   │   ├── handlers/
│   │   ├── tasks/
│   │   ├── templates/
│   │   └── vars/
│   │
│   └── nginx/
│       ├── defaults/
│       ├── handlers/
│       ├── tasks/
│       ├── templates/
│       └── vars/
```

---

# site.yml

```yaml
---
- name: Apply common configuration
  hosts: all
  become: true
  roles:
    - common

- name: Install Docker and run containers
  hosts: web
  become: true
  roles:
    - docker

- name: Configure Nginx reverse proxy
  hosts: web
  become: true
  roles:
    - nginx
```

---

# Common Role Tasks

```yaml
- Update package cache
- Install common packages
- Set hostname
- Set timezone
- Create deploy user
```

---

# Docker Role Tasks

```yaml
- Update apt cache
- Install Docker dependencies
- Start and enable Docker
- Add deploy user to docker group
- Pull application image
- Run application container
- Wait for container health check
- Docker Hub login using Vault variables
```

---

# Nginx Role Tasks

```yaml
- Install nginx
- Remove default site
- Deploy reverse proxy template
- Test nginx configuration
- Start and enable nginx
```

---

# Nginx Reverse Proxy Template

```nginx
upstream docker_app {
    server 127.0.0.1:8080;
}

server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://docker_app;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

# Selective Deployment Using Tags

Docker only:

```bash
ansible-playbook site.yml --tags docker
```

Nginx only:

```bash
ansible-playbook site.yml --tags nginx
```

Full deployment:

```bash
ansible-playbook site.yml
```

---

# Vault Integration

Vault was used to securely store Docker Hub credentials.

Create vault:

```bash
ansible-vault create group_vars/web/vault.yml
```

Example variables:

```yaml
vault_docker_username: <username>
vault_docker_password: <token>
```

Encrypted using:

```text
$ANSIBLE_VAULT;1.1;AES256
```

Vault password file configured in:

```ini
vault_password_file = .vault_pass
```

---

# Verification

## Verify Container Running

```bash
docker ps
```

Expected:

```text
CONTAINER ID   IMAGE          STATUS
nginx:latest   Up
```

---

## Verify Docker Health Check

```bash
curl http://localhost:8080
```

Expected:

```text
HTTP 200 OK
```

---

## Verify Nginx Reverse Proxy

```bash
curl -I http://localhost
```

Expected:

```text
HTTP/1.1 200 OK
Server: nginx
```

---

## Verify Listening Ports

```bash
ss -tulpn | grep -E ':80|:8080'
```

Expected:

```text
0.0.0.0:80
0.0.0.0:8080
```

---

## Verify Playbook Execution

```bash
ansible-playbook site.yml
```

Expected:

```text
failed=0
unreachable=0
```

---

## Verify Idempotency

Run playbook again:

```bash
ansible-playbook site.yml
```

Expected:

```text
No failures
Minimal or zero changes
```

---

# Screenshots Included

1. Project directory structure (`tree .`)
2. Successful playbook execution (`ansible-playbook site.yml`)
3. Docker container running (`docker ps`)
4. Nginx reverse proxy verification (`curl -I http://localhost`)
5. Vault encrypted file (`vault.yml`)
6. Browser showing application through Nginx
7. Idempotency verification run

---

# Outcome

Successfully automated deployment of a Dockerized application using Ansible Roles. Configured Nginx as a reverse proxy, secured credentials using Ansible Vault, implemented health checks, and verified end-to-end deployment on AWS EC2.
