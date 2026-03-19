## What is a GitHub-Hosted Runner?

A **GitHub-hosted runner** is a virtual machine provided by GitHub that runs the jobs defined in a GitHub Actions workflow.

When a workflow is triggered, GitHub automatically starts a temporary runner (VM), executes the job steps, and then shuts it down after the job finishes.

These runners come with pre-installed tools and support different operating systems such as:

- Ubuntu (Linux)
- Windows
- macOS

## Who Manages It?

GitHub-hosted runners are **fully managed by GitHub**.

GitHub is responsible for:
- Creating the virtual machines
- Maintaining the operating systems
- Installing common development tools
- Handling security updates
- Automatically cleaning up the environment after each job

Because GitHub manages everything, users do not need to set up or maintain their own infrastructure.




## Task 6: GitHub-Hosted vs Self-Hosted Runners

In GitHub Actions, runners are the machines that execute your CI/CD workflows. There are two types of runners: **GitHub-Hosted** and **Self-Hosted**.

### Comparison Table

| Feature | GitHub-Hosted | Self-Hosted |
|--------|---------------|-------------|
| **Who manages it?** | Managed and maintained by GitHub | Managed by the user or organization |
| **Cost** | Free for public repositories, limited free minutes for private repositories | No GitHub runner cost, but you pay for your own server or machine |
| **Pre-installed tools** | Comes with many tools pre-installed (Docker, Node.js, Python, Java, etc.) | You must install and maintain all required tools yourself |
| **Good for** | Quick setup, standard CI/CD pipelines, and open-source projects | Custom environments, special hardware needs, private network access |
| **Security concern** | Code runs on GitHub’s infrastructure | Full control over environment, but you must manage security |

### Summary

- **GitHub-Hosted Runners** are easy to use and require no setup since GitHub manages the infrastructure.
- **Self-Hosted Runners** give more control and customization but require manual setup and maintenance.

---
