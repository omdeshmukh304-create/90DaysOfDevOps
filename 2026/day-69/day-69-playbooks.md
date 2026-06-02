# Day 69 -- Ansible Playbooks and Modules

## Task 2: Understanding the Playbook Structure

### Playbook Structure

```yaml
---
- name: Play name
  hosts: web
  become: true

  tasks:
    - name: Task name
      module_name:
        key: value
```

### 1. What is the difference between a play and a task?

A play is a collection of tasks that runs on a specific group of hosts defined in the inventory. It determines where Ansible should execute the tasks.

A task is a single unit of work within a play. Each task uses an Ansible module to perform an action such as installing a package, starting a service, or copying a file.

**Play:** Defines the target hosts and groups related tasks together.

**Task:** Performs one specific action on the target hosts.

---

### 2. Can you have multiple plays in one playbook?

Yes. A single playbook can contain multiple plays. Each play can target different host groups and perform different sets of tasks.

For example, one play can configure web servers while another configures application servers.

---

### 3. What does `become: true` do at the play level vs the task level?

When `become: true` is defined at the play level, all tasks in that play run with elevated privileges (sudo/root).

When `become: true` is defined at the task level, only that specific task runs with elevated privileges.

Using it at the play level is useful when most tasks require administrative access.

---

### 4. What happens if a task fails? Do remaining tasks still run?

By default, if a task fails on a host, Ansible stops executing the remaining tasks for that host.

The remaining tasks will not run unless error handling mechanisms such as `ignore_errors: true` are used.

This behavior helps prevent further configuration changes when an earlier step has failed.

---

## Key Concepts Learned

* Playbook: A YAML file containing automation instructions.
* Play: A set of tasks executed on selected hosts.
* Task: A single action performed by Ansible.
* Module: The tool used by a task (apt, yum, service, copy, file, etc.).
* become: Used for privilege escalation (sudo/root).
* Idempotency: Running a playbook multiple times produces the same desired state without unnecessary changes.
