# Day 88 – Multi-Tool Agents, MCP, and CI/CD Analyzer

## Task

Yesterday you built a Docker-only agent. Today you extend it to handle both Docker AND Kubernetes, learn the Model Context Protocol (MCP) — the emerging standard for connecting AI to tools — and build a CI/CD Failure Analyzer that diagnoses broken GitHub Actions pipelines.

By the end of today, your agent can troubleshoot across three domains (Docker, Kubernetes, CI/CD) and your tools can be used by any MCP-compatible AI client, not just your Python script.

Reference: https://github.com/TrainWithShubham/agentic-ai-for-devops

---

# Challenge Tasks

---

# Task 1 – Build the Multi-Tool DevOps Agent

## Objective

Extend the Docker Troubleshooter Agent by adding Kubernetes tools, creating a single AI agent capable of troubleshooting both Docker containers and Kubernetes workloads.

## Docker Tools

- list_containers()
- get_logs(container_name)
- inspect_container(container_name)

## Kubernetes Tools

- list_pods(namespace)
- describe_pod(pod_name)
- get_events(namespace)

The agent uses the ReAct reasoning pattern to automatically decide which tool should be executed depending on the user's query.

### Example Questions

- What's broken across Docker and Kubernetes?
- Why is broken-pod crashing?
- Are there any unhealthy Docker containers?
- Describe the recent Kubernetes events.

---

## Multi-Tool Agent Architecture

```
                     User Question
                           │
                           ▼
                LangChain ReAct Agent
                           │
               ┌───────────┴───────────┐
               │                       │
         Docker Tools            Kubernetes Tools
               │                       │
     docker ps/logs/inspect     kubectl get/describe/events
               │                       │
               └───────────┬───────────┘
                           │
                     Tool Output
                           │
                           ▼
                    Final AI Response
```

---

### Screenshot


> 📸 Insert Screenshot: Multi-Tool Agent diagnosing Docker and Kubernetes issues.
![alt text](<WhatsApp Image 2026-06-30 at 3.10.13 PM.jpeg>)

# Day 88 – Multi-Tool Agents, MCP, and CI/CD Analyzer

## Task

Yesterday you built a Docker-only agent. Today you extend it to handle both Docker AND Kubernetes, learn the Model Context Protocol (MCP) — the emerging standard for connecting AI to tools — and build a CI/CD Failure Analyzer that diagnoses broken GitHub Actions pipelines.

By the end of today, your agent can troubleshoot across three domains (Docker, Kubernetes, CI/CD) and your tools can be used by any MCP-compatible AI client, not just your Python script.

Reference: https://github.com/TrainWithShubham/agentic-ai-for-devops

---

# Challenge Tasks

---

# Task 1 – Build the Multi-Tool DevOps Agent

## Objective

Extend the Docker Troubleshooter Agent by adding Kubernetes tools, creating a single AI agent capable of troubleshooting both Docker containers and Kubernetes workloads.

## Docker Tools

- list_containers()
- get_logs(container_name)
- inspect_container(container_name)

## Kubernetes Tools

- list_pods(namespace)
- describe_pod(pod_name)
- get_events(namespace)

The agent uses the ReAct reasoning pattern to automatically decide which tool should be executed depending on the user's query.

### Example Questions

- What's broken across Docker and Kubernetes?
- Why is broken-pod crashing?
- Are there any unhealthy Docker containers?
- Describe the recent Kubernetes events.

---

## Multi-Tool Agent Architecture

```
                     User Question
                           │
                           ▼
                LangChain ReAct Agent
                           │
               ┌───────────┴───────────┐
               │                       │
         Docker Tools            Kubernetes Tools
               │                       │
     docker ps/logs/inspect     kubectl get/describe/events
               │                       │
               └───────────┬───────────┘
                           │
                     Tool Output
                           │
                           ▼
                    Final AI Response
```

---


---

# Task 2 – Understanding MCP (Model Context Protocol)

## What is MCP?

Model Context Protocol (MCP) is an open standard introduced by Anthropic that allows AI models to communicate with external tools through a standardized interface.

Instead of embedding tools directly inside agent code, MCP exposes them as services that any compatible AI client can discover and use.

## Why MCP Matters

Without MCP

- Tools are tightly coupled with LangChain.
- Every AI framework needs its own implementation.
- Tools cannot easily be reused.

With MCP

- Write tools once.
- Use them from Claude Desktop.
- Use them from VS Code Copilot.
- Use them from Cursor.
- Use them from LangChain.
- Use them from Claude Code.

---

## MCP Architecture

```
                MCP Server
                     │
      ┌──────────────┼──────────────┐
      │              │              │
 list_pods()   describe_pod()   get_events()
      │              │              │
      └──────────────┼──────────────┘
                     │
          Model Context Protocol
                     │
      ┌──────────────┼──────────────┐
      │              │              │
 Claude Desktop   VS Code    LangChain Agent
```

---

## Hardcoded Tools vs MCP

| Hardcoded LangChain Tools | MCP Tools |
|----------------------------|-----------|
| Tools live inside the agent | Tools are exposed through an MCP server |
| Only usable inside one application | Reusable by multiple AI clients |
| Framework dependent | Framework independent |
| Difficult to reuse | Discoverable and reusable |

---

# Task 3 – Build and Use the MCP Server

## Objective

Expose Kubernetes tools using FastMCP and consume them dynamically using an MCP client.

## Components

### MCP Server

- FastMCP
- list_pods()
- describe_pod()
- get_events()

### MCP Client

- MultiServerMCPClient
- ChatOllama
- LangChain Agent

The client dynamically discovers available tools from the server instead of defining them locally.

---

### Screenshot

> 📸 Insert Screenshot: MCP Agent listing Kubernetes pods.
![alt text](<WhatsApp Image 2026-06-30 at 3.09.20 PM.jpeg>)
![alt text](<WhatsApp Image 2026-06-30 at 3.08.47 PM.jpeg>)
![alt text](<WhatsApp Image 2026-06-30 at 11.42.51 AM.jpeg>)

---

# Task 4 – Build the CI/CD Failure Analyzer

## Objective

Build an AI agent capable of diagnosing failed GitHub Actions workflows.

## GitHub CLI Tools

### list_workflow_runs()

Lists recent failed workflow runs.

### get_failed_logs()

Retrieves logs from failed workflow executions.

### get_workflow_file()

Reads GitHub Actions YAML workflow files.

---

## Questions Asked

- Show me the recent workflow runs.
- What failed in my last CI run?
- Read the ci.yml workflow file and explain what it does.

---

## Results

The CI/CD Analyzer successfully:

- Listed recent workflow executions.
- Identified the latest failed workflow.
- Explained the CI pipeline.
- Read the workflow YAML file.
- Explained the purpose of every job inside the workflow.

---

### Screenshot

> 📸 Insert Screenshot: CI/CD Failure Analyzer diagnosing failed workflow.
![alt text](<WhatsApp Image 2026-06-30 at 4.04.37 PM.jpeg>)
![alt text](<WhatsApp Image 2026-06-30 at 4.05.53 PM.jpeg>)
![alt text](<WhatsApp Image 2026-06-30 at 4.06.24 PM.jpeg>)
![alt text](<WhatsApp Image 2026-06-30 at 4.06.53 PM.jpeg>)
---

# Task 5 – Build Your Own Tool

## Selected Option

### Option C – Kubernetes Log Searcher

### Custom Tool

```python
@tool
def search_logs(keyword: str, namespace: str = "default"):
```

## Purpose

Searches every Kubernetes pod log inside a namespace and returns pods containing the requested keyword.

## Example Question

```
Search for the keyword "starting" in all Kubernetes pod logs.
```

## How the Agent Used It

The agent analyzed the user request.

It understood that searching Kubernetes logs required the custom `search_logs()` tool and attempted to execute it by requesting the namespace before performing the search.

This demonstrates how LLMs select tools based on their descriptions (docstrings) rather than hardcoded logic.

---

# Generic Tool Pattern

Every CLI tool follows the same pattern.

```python
@tool
def my_tool(argument: str) -> str:
    """
    Description that helps the LLM decide when to use this tool.
    """

    result = subprocess.run(
        ["some-cli", "command", argument],
        capture_output=True,
        text=True,
    )

    return result.stdout or result.stderr
```

This pattern works with:

- Docker
- Kubernetes
- Terraform
- AWS CLI
- GitHub CLI
- Linux commands
- Azure CLI
- GCP CLI
- Ansible
- Helm

Any CLI command can become an AI tool.

---

# Key Learnings

- Built a Multi-Tool DevOps Agent capable of troubleshooting Docker and Kubernetes.
- Learned the ReAct reasoning pattern for autonomous tool selection.
- Understood how Model Context Protocol enables tool sharing across multiple AI clients.
- Built an MCP Server using FastMCP.
- Connected an MCP Client using LangChain MCP Adapters.
- Built a CI/CD Failure Analyzer using GitHub CLI.
- Added a custom Kubernetes Log Searcher tool.
- Learned that AI agents become powerful by combining LLM reasoning with real CLI tools.

---

# Conclusion

Day 88 demonstrated how a single LLM can become a complete DevOps assistant by combining multiple CLI tools through the ReAct pattern.

By introducing MCP, tools become reusable across different AI clients instead of being tightly coupled to one application.

The same architecture can be extended to Kubernetes, Terraform, AWS, GitHub Actions, Helm, Ansible, or any other DevOps CLI, making AI agents a practical automation layer for modern DevOps workflows.
---

# Task 2 – Understanding MCP (Model Context Protocol)

## What is MCP?

Model Context Protocol (MCP) is an open standard introduced by Anthropic that allows AI models to communicate with external tools through a standardized interface.

Instead of embedding tools directly inside agent code, MCP exposes them as services that any compatible AI client can discover and use.

## Why MCP Matters

Without MCP

- Tools are tightly coupled with LangChain.
- Every AI framework needs its own implementation.
- Tools cannot easily be reused.

With MCP

- Write tools once.
- Use them from Claude Desktop.
- Use them from VS Code Copilot.
- Use them from Cursor.
- Use them from LangChain.
- Use them from Claude Code.

---

## MCP Architecture

```
                MCP Server
                     │
      ┌──────────────┼──────────────┐
      │              │              │
 list_pods()   describe_pod()   get_events()
      │              │              │
      └──────────────┼──────────────┘
                     │
          Model Context Protocol
                     │
      ┌──────────────┼──────────────┐
      │              │              │
 Claude Desktop   VS Code    LangChain Agent
```

---

## Hardcoded Tools vs MCP

| Hardcoded LangChain Tools | MCP Tools |
|----------------------------|-----------|
| Tools live inside the agent | Tools are exposed through an MCP server |
| Only usable inside one application | Reusable by multiple AI clients |
| Framework dependent | Framework independent |
| Difficult to reuse | Discoverable and reusable |

---

# Task 3 – Build and Use the MCP Server

## Objective

Expose Kubernetes tools using FastMCP and consume them dynamically using an MCP client.

## Components

### MCP Server

- FastMCP
- list_pods()
- describe_pod()
- get_events()

### MCP Client

- MultiServerMCPClient
- ChatOllama
- LangChain Agent

The client dynamically discovers available tools from the server instead of defining them locally.

---

### Screenshot

> 📸 Insert Screenshot: MCP Agent listing Kubernetes pods.

---

# Task 4 – Build the CI/CD Failure Analyzer

## Objective

Build an AI agent capable of diagnosing failed GitHub Actions workflows.

## GitHub CLI Tools

### list_workflow_runs()

Lists recent failed workflow runs.

### get_failed_logs()

Retrieves logs from failed workflow executions.

### get_workflow_file()

Reads GitHub Actions YAML workflow files.

---

## Questions Asked

- Show me the recent workflow runs.
- What failed in my last CI run?
- Read the ci.yml workflow file and explain what it does.

---

## Results

The CI/CD Analyzer successfully:

- Listed recent workflow executions.
- Identified the latest failed workflow.
- Explained the CI pipeline.
- Read the workflow YAML file.
- Explained the purpose of every job inside the workflow.

---

### Screenshot

> 📸 Insert Screenshot: CI/CD Failure Analyzer diagnosing failed workflow.

---

# Task 5 – Build Your Own Tool

## Selected Option

### Option C – Kubernetes Log Searcher

### Custom Tool

```python
@tool
def search_logs(keyword: str, namespace: str = "default"):
```

## Purpose

Searches every Kubernetes pod log inside a namespace and returns pods containing the requested keyword.

## Example Question

```
Search for the keyword "starting" in all Kubernetes pod logs.
```

## How the Agent Used It

The agent analyzed the user request.

It understood that searching Kubernetes logs required the custom `search_logs()` tool and attempted to execute it by requesting the namespace before performing the search.

This demonstrates how LLMs select tools based on their descriptions (docstrings) rather than hardcoded logic.

---

# Generic Tool Pattern

Every CLI tool follows the same pattern.

```python
@tool
def my_tool(argument: str) -> str:
    """
    Description that helps the LLM decide when to use this tool.
    """

    result = subprocess.run(
        ["some-cli", "command", argument],
        capture_output=True,
        text=True,
    )

    return result.stdout or result.stderr
```

This pattern works with:

- Docker
- Kubernetes
- Terraform
- AWS CLI
- GitHub CLI
- Linux commands
- Azure CLI
- GCP CLI
- Ansible
- Helm

Any CLI command can become an AI tool.

---

# Key Learnings

- Built a Multi-Tool DevOps Agent capable of troubleshooting Docker and Kubernetes.
- Learned the ReAct reasoning pattern for autonomous tool selection.
- Understood how Model Context Protocol enables tool sharing across multiple AI clients.
- Built an MCP Server using FastMCP.
- Connected an MCP Client using LangChain MCP Adapters.
- Built a CI/CD Failure Analyzer using GitHub CLI.
- Added a custom Kubernetes Log Searcher tool.
- Learned that AI agents become powerful by combining LLM reasoning with real CLI tools.

---

# Conclusion

Day 88 demonstrated how a single LLM can become a complete DevOps assistant by combining multiple CLI tools through the ReAct pattern.

By introducing MCP, tools become reusable across different AI clients instead of being tightly coupled to one application.

The same architecture can be extended to Kubernetes, Terraform, AWS, GitHub Actions, Helm, Ansible, or any other DevOps CLI, making AI agents a practical automation layer for modern DevOps workflows.