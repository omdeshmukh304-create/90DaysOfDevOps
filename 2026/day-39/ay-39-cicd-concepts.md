# Day 39 – What is CI/CD?


---


## Challenge Tasks

### Task 1: The Problem

Imagine a team of **5 developers** working on the same project and **manually deploying code to production**.

---

## 1. What can go wrong?

Many issues can happen when deployment is done manually:

- **Merge conflicts** when multiple developers push code at the same time.
- **Human errors** during manual deployment.
- **Wrong version deployed** to production.
- **Missing files or dependencies** during deployment.
- **Application downtime** if deployment fails.
- **No automated testing**, so bugs can reach production.
- **Inconsistent environments** between developer machines and production.

Manual processes increase the chances of mistakes and slow down development.

---

## 2. What does "It works on my machine" mean?

"It works on my machine" is a common phrase used when code runs correctly on a developer's computer but **fails on another machine or in production**.

### Why this happens

- Different **operating systems**
- Different **software versions**
- Missing **dependencies**
- Different **environment variables**
- Different **configuration settings**

### Why it is a real problem

This problem causes:

- Deployment failures
- Hard-to-debug issues
- Wasted developer time
- Delays in releasing features

CI/CD solves this by creating **consistent and automated build environments**.

---

## 3. How many times a day can a team safely deploy manually?

With manual deployment, teams usually deploy **once a day or even less**.

Reasons:

- Manual processes take time.
- High risk of human error.
- Deployments require coordination between team members.
- Fixing failures manually is slow.

With **CI/CD pipelines**, teams can safely deploy **multiple times a day** because testing and deployment are automated.

---

## Conclusion

Manual deployment is slow, risky, and error-prone.  
CI/CD pipelines automate building, testing, and deploying applications, allowing teams to release software **faster and more reliably**.


---


## Task 2: CI vs CD

### 1. Continuous Integration (CI)

Continuous Integration is the practice of automatically building and testing code whenever developers push changes to a shared repository.  
It helps detect integration issues, bugs, and build failures early in the development process.

**Real-world example:**  
A developer pushes code to GitHub, which automatically triggers a GitHub Actions workflow that installs dependencies, builds the application, and runs automated tests.

---

### 2. Continuous Delivery (CD)

Continuous Delivery is an extension of CI where the application is automatically prepared for release after passing build and test stages.  
The code is always kept in a deployable state, but deployment to production usually requires manual approval.

**Real-world example:**  
After CI tests pass, the pipeline builds a Docker image and pushes it to a container registry. The team can then manually approve deployment to the production server.

---

### 3. Continuous Deployment

Continuous Deployment goes one step further than Continuous Delivery.  
Every change that passes the automated pipeline is automatically deployed to production without manual intervention.

**Real-world example:**  
When code is merged into the main branch, the pipeline builds the app, runs tests, creates a Docker image, and automatically deploys the latest version to a cloud platform like AWS or Kubernetes.


---


### Task 3: Pipeline Anatomy

A CI/CD pipeline is made up of several components that work together to automate the build, test, and deployment process.

---

#### Trigger
A **trigger** is the event that starts a pipeline.  
Common triggers include pushing code to a repository, creating a pull request, or running a workflow manually.

**Example:**  
A developer pushes code to the `main` branch on GitHub, which automatically triggers a CI pipeline.

---

#### Stage
A **stage** is a logical phase in a pipeline that groups related jobs together.  
Typical stages include **build**, **test**, and **deploy**.

**Example:**  
A pipeline may have three stages: Build → Test → Deploy.

---

#### Job
A **job** is a set of tasks executed within a stage.  
Each job runs on a runner and performs a specific part of the pipeline process.

**Example:**  
A build stage may contain a job that installs dependencies and compiles the application.

---

#### Step
A **step** is the smallest unit of work in a pipeline.  
It represents a single command or action executed inside a job.

**Example:**  
Running `npm install` or `docker build` inside a job is considered a step.

---

#### Runner
A **runner** is the machine that executes pipeline jobs.  
It can be a cloud-hosted machine or a self-hosted server that runs the pipeline tasks.

**Example:**  
GitHub Actions uses **GitHub-hosted runners** like `ubuntu-latest` to execute workflows.

---

#### Artifact
An **artifact** is a file or output produced during a pipeline run that can be stored and used later.

**Example:**  
A compiled application, test report, or Docker image created during the build stage can be saved as an artifact.


---


### Task 4: Draw a Pipeline

Scenario:  
A developer pushes code to GitHub. The application is tested, built into a Docker image, and deployed to a staging server.

---

## CI/CD Pipeline Diagram





## Pipeline Flow

1. Developer pushes code to GitHub.
2. The CI pipeline is triggered automatically.
3. The **Test stage** runs automated tests to check the code.
4. The **Build stage** builds the application and creates a Docker image.
5. The **Deploy stage** deploys the Docker image to a **staging server** for testing.



---


### Task 5: Explore in the Wild

Repository explored: **FastAPI**

GitHub Repository: https://github.com/fastapi/fastapi

Workflow file inspected: `.github/workflows/test.yml`

---

## 1. What triggers it?

The workflow is triggered when:

- Code is **pushed** to the repository
- A **pull request** is created or updated

This ensures that every change made to the project is automatically tested before being merged.

---

## 2. How many jobs does it have?

The workflow contains **multiple jobs**, mainly focused on:

- Running tests on different **Python versions**
- Checking **code quality and formatting**
- Validating the project build

These jobs may run in parallel to speed up the CI process.

---

## 3. What does it do? (Best guess)

The workflow is mainly used for **Continuous Integration (CI)**.  
Its purpose is to make sure the code works correctly before it is merged into the main branch.

Main actions performed:

- Set up a Python environment
- Install project dependencies
- Run automated tests using `pytest`
- Check code formatting and linting
- Ensure the application builds correctly

---

## Summary

This workflow helps maintain code quality by automatically testing the project whenever developers contribute new code. It prevents bugs from being merged into the main codebase and ensures the project remains stable.