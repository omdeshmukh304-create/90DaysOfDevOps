# Day 41 – Triggers & Matrix Builds

Today I learned how different triggers start GitHub Actions workflows and how matrix builds allow running the same job across multiple environments.

---

# Task 1 – Pull Request Trigger

Created a workflow **`.github/workflows/pr-check.yml`** that runs when a pull request is **opened or updated** against the `main` branch.

## Trigger Configuration

```yaml
name: PR Check

on:
  pull_request:
    branches: [main]
    types: [opened, synchronize]

jobs:
  pr-check:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Print PR branch
        run: echo "PR check running for branch: ${{ github.head_ref }}"
```

This workflow automatically runs whenever a pull request is created or updated for the **main branch**.

---

# Task 2 – Scheduled Trigger

Added a **schedule trigger** using cron syntax.

## Example

```yaml
on:
  schedule:
    - cron: '0 0 * * *'
```

This workflow runs **every day at midnight (UTC)**.

## Cron Breakdown

| Field        | Value | Meaning              |
| ------------ | ----- | -------------------- |
| Minute       | 0     | At minute 0          |
| Hour         | 0     | At hour 0 (midnight) |
| Day of Month | *     | Every day            |
| Month        | *     | Every month          |
| Day of Week  | *     | Any day              |

## Question

**Cron expression for every Monday at 9 AM**

```
0 9 * * 1
```

Meaning: Run the workflow **every Monday at 9:00 AM**.

---

# Task 3 – Manual Trigger

Created a workflow **`.github/workflows/manual.yml`** using `workflow_dispatch`.

This allows the workflow to be triggered **manually from the GitHub Actions tab**.

## Example

```yaml
name: Manual Workflow

on:
  workflow_dispatch:
    inputs:
      environment:
        description: "Select environment"
        required: true
        type: choice
        options:
          - staging
          - production

jobs:
  manual-run:
    runs-on: ubuntu-latest

    steps:
      - name: Print environment
        run: echo "Deploying to environment: ${{ github.event.inputs.environment }}"
```

Example output:

```
Deploying to environment: staging
```

---

# Task 4 – Matrix Builds

Used a **matrix strategy** to run the same job across multiple environments.

## Matrix Configuration

* Python versions: `3.10`, `3.11`, `3.12`
* Operating systems: `ubuntu-latest`, `windows-latest`

## Example

```yaml
name: Python Matrix

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ${{ matrix.os }}

    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest]
        python-version: [3.10, 3.11, 3.12]

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - run: python --version
```

## Total Jobs

```
2 Operating Systems × 3 Python Versions = 6 Jobs
```

## Jobs Executed

| OS      | Python |
| ------- | ------ |
| Ubuntu  | 3.10   |
| Ubuntu  | 3.11   |
| Ubuntu  | 3.12   |
| Windows | 3.10   |
| Windows | 3.11   |
| Windows | 3.12   |

All jobs run **in parallel**.

---

# Task 5 – Exclude & Fail-Fast

Used **exclude** to remove a specific matrix combination.

## Example

```yaml
strategy:
  fail-fast: false
  matrix:
    os: [ubuntu-latest, windows-latest]
    python-version: [3.10, 3.11, 3.12]

    exclude:
      - os: windows-latest
        python-version: 3.10
```

This removes the combination:

```
Windows + Python 3.10
```

## Jobs After Exclude

```
Original jobs = 6
Excluded combination = 1
Remaining jobs = 5
```

---

# Fail-Fast Behavior

## fail-fast: true (default)

If one matrix job fails, all remaining jobs are **cancelled**.

Example:

```
Job 1 ❌ Failed
Job 2 ⛔ Cancelled
Job 3 ⛔ Cancelled
```

Purpose: Save CI time and resources.

---

## fail-fast: false

If one job fails, the remaining jobs **continue running**.

Example:

```
Job 1 ❌ Failed
Job 2 ✅ Running
Job 3 ✅ Running
```

Purpose: Identify failures across multiple environments.

---

# Key Learnings

* GitHub workflows can be triggered by **push, pull request, schedule, or manual triggers**.
* **Matrix builds** allow running the same job across multiple environments.
* `exclude` removes unsupported combinations.
* `fail-fast` controls whether other matrix jobs stop when one fails.

---

# Summary

Today I explored **workflow triggers and matrix builds in GitHub Actions**, which are essential for building scalable CI/CD pipelines that test applications across multiple environments.
