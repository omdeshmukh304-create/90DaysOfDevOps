# Day 71 - Roles, Templates and Vault

## Objective

Learn how to organize Ansible automation using Roles, create dynamic configuration files using Jinja2 Templates, securely store secrets using Ansible Vault, and use community roles from Ansible Galaxy.

---

# 1. Webserver Role Directory Structure

Created a reusable role named `webserver`.

```text
roles/
└── webserver/
    ├── defaults/
    │   └── main.yml
    ├── files/
    ├── handlers/
    │   └── main.yml
    ├── meta/
    │   └── main.yml
    ├── tasks/
    │   └── main.yml
    ├── templates/
    ├── tests/
    └── vars/
        └── main.yml
```

### tasks/main.yml

```yaml
---
- name: Install Nginx
  apt:
    name: nginx
    state: present
    update_cache: yes

- name: Start Nginx
  service:
    name: nginx
    state: started
    enabled: true
```

---

# 2. Jinja2 Template

Template file:

```text
templates/db-config.j2
```

Contents:

```jinja2
# Database Configuration -- Managed by Ansible

DB_HOST={{ ansible_default_ipv4.address }}
DB_PORT={{ db_port | default(3306) }}

DB_PASSWORD={{ vault_db_password }}
DB_ROOT_PASSWORD={{ vault_db_root_password }}
```

---

# 3. Rendered Output

Generated file:

```text
/etc/db-config.env
```

Example output:

```env
# Database Configuration -- Managed by Ansible

DB_HOST=172.31.11.200
DB_PORT=3306

DB_PASSWORD=mydbpassword
DB_ROOT_PASSWORD=rootpassword
```

Permissions:

```bash
-rw------- 1 root root ...
```

Permission `0600` ensures only root can read and write the file.

---

# 4. Role Execution Screenshot

Insert screenshot of successful role execution here.

Example:

```text
TASK [webserver : Install Nginx] ********
ok: [web-server]

TASK [webserver : Start Nginx] **********
ok: [web-server]
```

Screenshot:

![Role Execution Screenshot](screenshots/webserver-role-success.png)

---

# 5. Installing and Using a Galaxy Role

Installed Docker role from Ansible Galaxy:

```bash
ansible-galaxy install geerlingguy.docker
```

Verify installation:

```bash
ansible-galaxy list
```

Output:

```text
geerlingguy.docker, 7.4.1
```

Used in playbook:

```yaml
- name: Configure app servers with Docker
  hosts: application
  become: true

  roles:
    - geerlingguy.docker
```

Result:

* Docker installed
* Docker service enabled
* Docker service started

---

# 6. Vault Workflow

## Create Vault

```bash
ansible-vault create vault.yml
```

Contents:

```yaml
vault_db_password: mydbpassword
vault_db_root_password: rootpassword
```

---

## View Vault

```bash
ansible-vault view vault.yml
```

---

## Edit Vault

```bash
ansible-vault edit vault.yml
```

---

## Encrypt Existing File

```bash
ansible-vault encrypt secrets.yml
```

---

## Decrypt File

```bash
ansible-vault decrypt vault.yml
```

---

## Re-encrypt File

```bash
ansible-vault encrypt vault.yml
```

---

# 7. Encrypted Vault File Screenshot

Encrypted file contents:

```text
$ANSIBLE_VAULT;1.1;AES256
663630363730323063386136383939643264653136326537...
```

Screenshot:

![Vault Screenshot](screenshots/vault-encrypted-file.png)

---

# 8. Complete Site Playbook

```yaml
---
- name: Configure web servers
  hosts: web
  become: true

  roles:
    - role: webserver

- name: Configure app servers with Docker
  hosts: application
  become: true

  roles:
    - geerlingguy.docker

- name: Configure database servers
  hosts: database
  become: true

  vars_files:
    - vault.yml

  tasks:
    - name: Create DB config with secrets
      template:
        src: templates/db-config.j2
        dest: /etc/db-config.env
        owner: root
        group: root
        mode: '0600'
```

---

# 9. Roles vs Playbooks vs Ad-hoc Commands

## Ad-hoc Commands

Used for quick one-time tasks.

Example:

```bash
ansible all -m ping
ansible all -a "uptime"
```

Use when:

* Quick checks
* Temporary actions
* Troubleshooting

---

## Playbooks

Used for repeatable automation.

Example:

```yaml
- hosts: web
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
```

Use when:

* Multiple tasks are required
* Infrastructure setup
* Configuration management

---

## Roles

Used for large reusable automation projects.

Example:

```text
roles/
└── webserver/
```

Use when:

* Multiple playbooks need same configuration
* Standardized server setups
* Production automation

Benefits:

* Reusable
* Organized
* Easy maintenance
* Team collaboration

---

# Conclusion

In this lab I learned:

* Creating and using Ansible Roles
* Installing roles from Ansible Galaxy
* Building dynamic configuration files with Jinja2 Templates
* Securing secrets using Ansible Vault
* Managing multi-tier infrastructure with a single playbook
* Understanding when to use ad-hoc commands, playbooks, and roles

Day 71 successfully completed.
