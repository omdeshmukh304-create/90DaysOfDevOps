# Day 87 – Introduction to Agentic AI for DevOps

## Overview

Day 87 introduces **Agentic AI for DevOps**. Unlike traditional chatbots, AI agents can use tools such as Docker CLI, Kubernetes CLI, GitHub CLI, and APIs to inspect systems, diagnose issues, and perform actions autonomously.

---

# Task 1 – Understand Agentic AI for DevOps

## Question 1: What is an AI Agent?

### Answer

An AI Agent is a Large Language Model (LLM) that can use external **tools** to interact with real systems.

Unlike a chatbot that only generates text, an AI agent can:

* Execute terminal commands
* Read files
* Call APIs
* Analyze command outputs
* Decide what action to take next

The LLM acts as the **brain**, while tools act as the **hands**.

Example:

User:

```
Show my running Docker containers.
```

Agent:

```
Runs: docker ps
Reads the output
Explains which containers are running
```

---

## Question 2: Why Agents for DevOps?

### Answer

DevOps engineers work mainly with CLI tools such as:

* Docker
* Kubernetes (kubectl)
* Terraform
* GitHub CLI (gh)
* Ansible

An AI agent wraps these CLI commands as tools and automatically chooses the correct one based on the user's request.

Example:

User:

```
Why is my pod crashing?
```

Agent workflow:

```
kubectl get pods
        ↓
CrashLoopBackOff detected
        ↓
kubectl describe pod
        ↓
Reads Events
        ↓
Explains root cause
```

This reduces manual troubleshooting and speeds up debugging.

---

## Question 3: Explain the ReAct Pattern

### Answer

ReAct stands for:

**Reason + Act**

Instead of guessing an answer, the agent repeatedly thinks, performs an action, observes the result, and decides the next action.

Example:

```
User:
Why is broken-app crashing?

THINK
I should check the containers.

ACT
list_containers()

OBSERVE
broken-app is Exited (1)

THINK
Check the logs.

ACT
get_logs("broken-app")

OBSERVE
app starting...
exit code 1

THINK
Inspect container.

ACT
inspect_container("broken-app")

OBSERVE
ExitCode = 1

ANSWER
The container exits because the startup command finishes with exit code 1.
```

---

## Question 4: What are the key components?

### Answer

### LLM (Brain)

Responsible for reasoning and deciding which tool to use.

Examples:

* Ollama
* Gemma
* GPT
* Claude

---

### Tools (Hands)

Python functions that execute CLI commands.

Examples:

```
docker ps
kubectl get pods
terraform plan
gh repo list
```

---

### Agent Framework

Controls the reasoning loop.

Used in this project:

* LangChain
* create_react_agent()

---

### MCP (Model Context Protocol)

A standard protocol that allows AI systems to access tools and external resources consistently.

Covered in Day 88.

---

# Task 2 – Set Up the Environment

## Commands Used

Clone repository

```bash
git clone https://github.com/TrainWithShubham/agentic-ai-for-devops.git
cd agentic-ai-for-devops
```

Install Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Create Python virtual environment

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Install dependencies

```bash
pip install -r requirements.txt
```

Verify setup

```bash
python3 module-0/verify_setup.py
```

### verify_setup.py Output

```
Checking your setup...

[PASS] Python 3.10+
[PASS] Docker
[PASS] kubectl
[PASS] Kind
[PASS] Ollama + gemma4

5/5 — you're ready for Day 1!
```

---

# Task 3 – Docker Error Explainer

## Objective

Build a simple LLM application that explains Docker errors.

The application sends:

* System Prompt
* User Docker Error

to the LLM using:

```python
ollama.chat(...)
```

No tools are used.

---

## System Prompt

```
You are a Docker expert.

When given a Docker error, explain:

1. What went wrong
2. Most likely cause
3. How to fix it

Keep it short.
```

---

## Temperature

```
temperature = 0.3
```

Lower temperature produces:

* More deterministic answers
* Better technical explanations
* Less randomness

---

## Screenshot

**( screenshot of Docker Error Explainer here.)**
![alt text](<WhatsApp Image 2026-06-30 at 9.48.51 AM.jpeg>)
---

# Task 4 – Docker Troubleshooter Agent

## Objective

Build an AI Agent capable of diagnosing Docker problems using tools.

Available tools:

```
list_containers()

↓

docker ps -a
```

```
get_logs()

↓

docker logs
```

```
inspect_container()

↓

docker inspect
```

The agent reasons about which tool to call and in what order.

### Note

Due to local model compatibility and memory limitations, the complete troubleshooting flow could not be demonstrated on this machine, but the agent architecture, tool integration, and workflow were successfully studied and understood.

---



---

# Task 5 – Agent Architecture

```
                User
                  │
                  ▼
      "Why is broken-app crashing?"
                  │
                  ▼
      LLM (Gemma/Qwen via Ollama)
                  │
      Reasons which tool to use
                  │
                  ▼
            Tool Selection
       ┌────────┼────────┐
       │        │        │
       ▼        ▼        ▼
 list_containers
 get_logs
 inspect_container
       │        │        │
       ▼        ▼        ▼
 docker ps  docker logs  docker inspect
           │
           ▼
      Tool Output
           │
           ▼
    LLM reasons again
           │
           ▼
      Final Answer
```

---

## Why this matters

The architecture is reusable.

Replace Docker tools with:

* Kubernetes tools
* Terraform tools
* AWS CLI tools
* Ansible tools

The agent architecture remains exactly the same.

---

# Task 6 – Experiment and Extend

## Added Tool

```python
@tool
def list_images() -> str:
    """List all Docker images on this machine with their sizes."""
    result = subprocess.run(
        ["docker", "images"],
        capture_output=True,
        text=True,
    )
    return result.stdout or result.stderr
```

Added to:

```python
tools = [
    list_containers,
    get_logs,
    inspect_container,
    list_images
]
```

### How the Agent Uses It

User:

```
What images do I have and how much space are they using?
```

Agent flow:

```
LLM
    ↓
Chooses list_images()
    ↓
Runs docker images
    ↓
Reads output
    ↓
Explains image list and sizes
```

---

## Safety Considerations

Adding powerful tools such as:

```
restart_container()
```

allows the AI to perform actions on real infrastructure.

In production, guardrails should be implemented, such as:

* Confirmation prompts
* Allow lists
* Role-based permissions
* Audit logging

These concepts are introduced in Day 89.

---

# Key Learnings

* Learned what AI Agents are and how they differ from chatbots.
* Understood the ReAct (Reason + Act) pattern.
* Set up the complete local Agentic AI environment.
* Built a Docker Error Explainer using Ollama.
* Learned how LangChain tools work with `@tool`.
* Understood how `subprocess.run()` enables CLI automation.
* Studied the architecture of an AI troubleshooting agent.
* Learned how easily new tools can be added to an agent.
* Understood why guardrails are important before allowing AI to perform production actions.
