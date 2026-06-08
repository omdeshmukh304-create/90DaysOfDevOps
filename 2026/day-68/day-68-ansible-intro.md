# Day 68 -- Introduction to Ansible and Inventory Setup


# Task 1: Understanding Ansible

## 1. What is Configuration Management? Why do we need it?

Configuration Management is the process of maintaining servers and systems in a desired and consistent state. It automates tasks such as installing software, configuring services, managing users, and updating system settings.

### Why do we need it?

* Eliminates manual server configuration.
* Ensures consistency across multiple servers.
* Reduces human errors.
* Saves time and effort.
* Makes infrastructure reproducible and scalable.

For example, if 100 servers need Nginx installed and configured, a configuration management tool can perform the task automatically on all servers.

---

## 2. How is Ansible different from Chef, Puppet, and Salt?

| Feature          | Ansible | Chef         | Puppet       | Salt         |
| ---------------- | ------- | ------------ | ------------ | ------------ |
| Agent Required   | No      | Yes          | Yes          | Usually Yes  |
| Language         | YAML    | Ruby DSL     | Puppet DSL   | YAML/Python  |
| Learning Curve   | Easy    | Moderate     | Moderate     | Moderate     |
| Communication    | SSH     | Agent-Server | Agent-Server | Agent-Server |
| Setup Complexity | Simple  | Complex      | Complex      | Medium       |

### Why Ansible is popular

* Agentless architecture.
* Easy-to-read YAML syntax.
* Quick setup and deployment.
* Uses standard SSH for communication.

---

## 3. What does "Agentless" mean? How does Ansible connect to managed nodes?

Agentless means no software agent needs to be installed on the target servers.

Ansible connects to managed nodes using SSH (Linux) or WinRM (Windows). The control node sends commands and modules directly to the target machines, executes them, and receives the results.

### Advantages of Agentless Architecture

* Easier maintenance.
* Lower resource usage.
* Faster setup.
* Improved security by using existing SSH infrastructure.

---

## 4. Ansible Architecture

### Components

#### Control Node

The machine where Ansible is installed and executed. It can be a laptop, workstation, or jump server.

#### Managed Nodes

The servers that Ansible manages and configures. These are typically EC2 instances, virtual machines, or physical servers.

#### Inventory

A file containing the list of managed nodes and groups.

Example:

```ini
[web]
web1
web2

[db]
db1
```

#### Modules

Small programs that perform specific tasks such as:

* Install packages
* Create users
* Copy files
* Start services

Examples:

* apt
* yum
* copy
* service
* user

#### Playbooks

YAML files that define automation tasks and the hosts on which they run.

Example:

```yaml
- hosts: web
  become: yes
  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: present
```

### Architecture Diagram

```text
+-------------------+
|   Control Node    |
|     (Ansible)     |
+---------+---------+
          |
          | SSH
          |
  ---------------------
  |         |         |
  |         |         |
+----+   +----+   +----+
|EC2 |   |EC2 |   |EC2 |
|Node|   |Node|   |Node|
+----+   +----+   +----+

Inventory -> List of Hosts
Modules   -> Tasks Executed
Playbooks -> Automation Definitions
```


## Task 3: Install Ansible


### Why is Ansible installed only on the Control Node?

Ansible follows an agentless architecture. It does not require any software installation on managed nodes. The Control Node connects to remote servers using SSH, executes tasks, and receives results. Therefore, Ansible only needs to be installed on the Control Node, while the managed nodes only need SSH access.

### Task 4: Create Your Inventory File


### Verification

Command:

```bash
ansible all -i inventory.ini -m ping
```

Output:

```text
web-server | SUCCESS => {
    "ping": "pong"
}

app-server | SUCCESS => {
    "ping": "pong"
}

db-server | SUCCESS => {
    "ping": "pong"
}
```

Result:
Ansible successfully connected to all managed nodes using SSH and returned a pong response from each server.

### Task 5: Run Ad-Hoc Commands

## What does --become do?

The `--become` flag allows Ansible to execute tasks with elevated privileges, usually as the root user using `sudo`.

Example:

```bash
ansible web -i inventory.ini -m apt -a "name=git state=present" --become
```

Installing packages, managing services, creating system users, modifying system configuration files, and other administrative tasks require root privileges. In such cases, `--become` is needed.

Without `--become`, Ansible runs commands as the remote login user (in this lab, the `ubuntu` user).

