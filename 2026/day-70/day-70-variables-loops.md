# Day 70 - Variables, Facts, Conditionals and Loops

## Objective

Learned how to use variables, facts, conditionals, loops, and register statements to make Ansible playbooks dynamic and reusable.

---

# Task 1: Variables in Playbooks

## Playbook Variables

Variables used:

```yaml
vars:
  app_name: terraweek-app
  app_port: 8080
  app_dir: "/opt/{{ app_name }}"
```

## Command Used

```bash
ansible-playbook variables-demo.yml
```

## Variable Override Test

```bash
ansible-playbook variables-demo.yml -e "app_name=my-custom-app app_port=9090"
```

## Verification

Yes. Variables passed using `-e` successfully overrode playbook variables.

Example:

| Variable | Playbook Value | CLI Value     | Result        |
| -------- | -------------- | ------------- | ------------- |
| app_name | terraweek-app  | my-custom-app | my-custom-app |
| app_port | 8080           | 9090          | 9090          |

---

# Task 2: group_vars and host_vars

## Directory Structure

```text
ansible-practice/
├── inventory.ini
├── ansible.cfg
├── group_vars/
│   ├── all.yml
│   ├── web.yml
│   └── db.yml
├── host_vars/
│   └── web-server.yml
└── playbooks/
    └── site.yml
```

## Variable Precedence

Highest priority to lowest:

1. Extra Variables (`-e`)
2. host_vars
3. group_vars
4. Playbook vars
5. Role defaults

### Example

group_vars/web.yml

```yaml
max_connections: 1000
```

host_vars/web-server.yml

```yaml
max_connections: 2000
```

Result:

```text
web-server => 2000
```

because host_vars overrides group_vars.

CLI Example:

```bash
ansible-playbook site.yml -e "max_connections=5000"
```

Result:

```text
max_connections => 5000
```

because extra vars override everything.

---

# Task 3: Ansible Facts

## Commands Used

```bash
ansible web-server -m setup
```

```bash
ansible web-server -m setup -a "filter=ansible_os_family"
```

```bash
ansible web-server -m setup -a "filter=ansible_distribution*"
```

```bash
ansible web-server -m setup -a "filter=ansible_memtotal_mb"
```

```bash
ansible web-server -m setup -a "filter=ansible_default_ipv4"
```

## Five Useful Facts

### 1. ansible_distribution

Used to determine operating system.

Example:

```yaml
when: ansible_distribution == "Ubuntu"
```

### 2. ansible_os_family

Used when managing multiple Linux distributions.

Example:

```yaml
when: ansible_os_family == "RedHat"
```

### 3. ansible_memtotal_mb

Used for memory-based configuration decisions.

Example:

```yaml
when: ansible_memtotal_mb < 1024
```

### 4. ansible_default_ipv4.address

Used to identify server IP addresses.

Example:

```yaml
msg: "{{ ansible_default_ipv4.address }}"
```

### 5. ansible_hostname

Used for reporting and logging.

Example:

```yaml
msg: "{{ ansible_hostname }}"
```

---

# Task 4: Conditionals with when

## Example Conditions

```yaml
when: "'web' in group_names"
```

```yaml
when: ansible_distribution == "Ubuntu"
```

```yaml
when: ansible_memtotal_mb < 1024
```

## Verification

Tasks executed only on matching hosts.

Tasks that did not meet conditions were marked as:

```text
skipping: [host-name]
```

## Screenshot

(Insert screenshot showing executed and skipped tasks)

---

# Task 5: Loops

## Creating Multiple Users

```yaml
loop: "{{ users }}"
```

## Creating Multiple Directories

```yaml
loop: "{{ directories }}"
```

## Difference Between loop and with_items

| loop                            | with_items       |
| ------------------------------- | ---------------- |
| Modern syntax                   | Older syntax     |
| Recommended                     | Deprecated style |
| More readable                   | Less flexible    |
| Better integration with filters | Older approach   |

Conclusion:

Use `loop` in all new playbooks.

## Screenshot

(Insert screenshot showing loop iterations)

---

# Task 6: Server Health Report

## Concepts Used

* Facts
* Variables
* Register
* Command Module
* Shell Module
* Conditionals

## Registered Variables

```yaml
register: disk_result
register: memory_result
register: services_result
```

## Sample Report Output

```text
========== web-server ==========
OS: Ubuntu 24.04
IP: 172.31.x.x
RAM: 950MB
Disk: /dev/root 8G 2G 6G 25%
Running services (first 20): 20
```

## Generated Report File

```text
/tmp/server-report-web-server.txt
```

## Verification

Successfully connected to the server and verified that:

```bash
cat /tmp/server-report-web-server.txt
```

contained accurate hostname, OS, IP, memory, and disk information.

---

# Key Learnings

* Variables make playbooks reusable.
* group_vars and host_vars separate configuration from code.
* Facts provide system information automatically.
* Conditionals allow selective execution.
* Loops reduce repetitive tasks.
* Register stores command output for later use.
* Combining all features creates dynamic infrastructure automation.
