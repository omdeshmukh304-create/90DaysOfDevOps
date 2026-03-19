### Task 1: GitHub Secrets

#### What are GitHub Secrets?
GitHub Secrets are used to store sensitive information securely inside a repository.  
Examples include API keys, passwords, tokens, and private credentials that should not be exposed in code.

Secrets are encrypted and can be accessed inside GitHub Actions workflows using:
`${{ secrets.SECRET_NAME }}`

---

### Steps Performed

1. Opened the repository.
2. Navigated to **Settings → Secrets and Variables → Actions**.
3. Created a new repository secret named:

```
MY_SECRET_MESSAGE
```

4. Created a workflow to check if the secret exists without printing its value.

---

### Example Workflow

```yaml
name: Secret Test Pipeline

on:
  push:

jobs:
  check-secret:
    runs-on: ubuntu-latest

    steps:
      - name: Check if secret exists
        run: |
          if [ -n "${{ secrets.MY_SECRET_MESSAGE }}" ]; then
            echo "The secret is set: true"
          else
            echo "The secret is set: false"
          fi
```

---

### What happens if we print the secret?

If we try to print the secret directly like this:

```yaml
echo "${{ secrets.MY_SECRET_MESSAGE }}"
```

GitHub automatically **masks the value** in the logs and shows:

```
***
```

This prevents sensitive information from being exposed.

---

### Why should you never print secrets in CI logs?

You should never print secrets in CI logs because:

- CI logs are often **public or accessible to collaborators**
- Anyone with access to the logs could **steal credentials**
- Exposed secrets could allow attackers to **access APIs, databases, or cloud resources**
- It is a **major security risk**

Best practice is to **use secrets internally in workflows without displaying them**.

---

### Key Learning

- Secrets store sensitive values securely.
- They are accessed using `${{ secrets.SECRET_NAME }}`.
- GitHub masks secrets in logs to prevent exposure.
- Never print secrets in CI pipelines.


### Task 2: Use Secrets as Environment Variables

#### Objective
Use GitHub Secrets as environment variables inside a workflow step so that sensitive information is never hardcoded in the pipeline.

---

### Steps Performed

1. Added the following secrets in the repository:

Repository → **Settings → Secrets and Variables → Actions**

Created secrets:

```
DOCKER_USERNAME
DOCKER_TOKEN
```

These will be used later for **Docker authentication in CI/CD (Day 45)**.

---

### Passing Secrets as Environment Variables

Secrets can be passed to workflow steps using the `env` keyword.

Example workflow step:

```yaml
name: Secret Environment Variable Test

on:
  push:

jobs:
  use-secret-env:
    runs-on: ubuntu-latest

    steps:
      - name: Use secrets as environment variables
        env:
          DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
          DOCKER_TOKEN: ${{ secrets.DOCKER_TOKEN }}

        run: |
          echo "Using Docker credentials securely"
          echo "Docker username is set"
```

---

### Explanation

- `env` is used to create environment variables inside the step.
- The secret values are accessed using:

```
${{ secrets.SECRET_NAME }}
```

- The secret values are **not printed** in logs.
- This allows secure usage of credentials in commands like:

```
docker login
```

---

### Example Real Use Case (Docker Login)

```yaml
run: |
  echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USERNAME" --password-stdin
```

This logs into Docker securely without exposing the password.

---

### Best Practices

- Never hardcode credentials in workflow files.
- Always store sensitive values in **GitHub Secrets**.
- Pass secrets as **environment variables** instead of printing them.

---

### Key Learning

- Secrets can be safely used in workflows through environment variables.
- GitHub automatically masks secret values in logs.
- This method enables secure authentication in CI pipelines.


### Task 3: Upload Artifacts

#### Objective
Artifacts are files generated during a CI workflow that we want to save after the job finishes.  
They can include logs, build outputs, test reports, or compiled binaries.

GitHub Actions allows us to store these files using the **upload-artifact action**.

---

### Step 1: Generate a File

Create a step in the workflow that generates a file such as a test report or log file.

Example:

```yaml
- name: Generate Test Report
  run: |
    echo "Test execution started" > test-report.txt
    echo "All tests passed successfully" >> test-report.txt
```

This creates a file called:

```
test-report.txt
```

---

### Step 2: Upload the Artifact

Use the `actions/upload-artifact` action to save the file.

```yaml
- name: Upload Artifact
  uses: actions/upload-artifact@v4
  with:
    name: test-report
    path: test-report.txt
```

Explanation:

- **name** → Name of the artifact stored in GitHub
- **path** → File or folder to upload

---

### Full Example Workflow

```yaml
name: Artifact Example

on:
  push:

jobs:
  artifact-demo:
    runs-on: ubuntu-latest

    steps:
      - name: Generate Test Report
        run: |
          echo "Test execution started" > test-report.txt
          echo "All tests passed successfully" >> test-report.txt

      - name: Upload Artifact
        uses: actions/upload-artifact@v4
        with:
          name: test-report
          path: test-report.txt
```

---

### Step 3: Download the Artifact

After the workflow finishes:

1. Go to your repository
2. Click **Actions**
3. Open the workflow run
4. Scroll to **Artifacts**
5. Download **test-report**

---

### Verification

Yes, the artifact can be viewed and downloaded from the **GitHub Actions tab** after the workflow run completes.

---

### Key Learning

- Artifacts store files generated during CI pipelines.
- They help preserve logs, reports, and build outputs.
- They can be downloaded later from the **Actions tab** in GitHub.



### Task 4: Download Artifacts Between Jobs

#### Objective
Artifacts can be shared between jobs in a workflow.  
One job can generate a file and upload it, and another job can download and use it.

---

### Job 1: Generate and Upload Artifact

This job creates a file and uploads it as an artifact.

### Job 2: Download and Use Artifact

This job downloads the artifact created in Job 1 and prints its contents.

---

### Example Workflow

```yaml
name: Artifact Sharing Between Jobs

on:
  push:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Generate file
        run: |
          echo "Hello from Job 1" > message.txt

      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: message-file
          path: message.txt

  consume:
    runs-on: ubuntu-latest
    needs: build

    steps:
      - name: Download artifact
        uses: actions/download-artifact@v4
        with:
          name: message-file

      - name: Print artifact content
        run: |
          cat message.txt
```

---

### How it Works

1. **Job `build`**
   - Creates a file `message.txt`
   - Uploads it as an artifact named `message-file`

2. **Job `consume`**
   - Waits for `build` to finish (`needs: build`)
   - Downloads the artifact
   - Prints the contents using `cat message.txt`

---

### When would you use artifacts in a real pipeline?

Artifacts are useful when one job produces output that another job needs.

Common real-world examples:

- Saving **build files** and using them in a deployment job
- Sharing **test reports** between testing and reporting jobs
- Passing **compiled binaries** to a release pipeline
- Storing **logs and debugging files**
- Sharing **Docker build outputs or packages**

Artifacts help pipelines stay **modular, reusable, and efficient**.

---

### Key Learning

- Artifacts allow data sharing between jobs.
- `upload-artifact` saves files.
- `download-artifact` retrieves them in another job.
- They are commonly used for build outputs, logs, and reports.




### Task 5: Run Real Tests in CI

#### Objective
Run a real script inside the CI pipeline so that the workflow fails if the script exits with a non-zero status code.

---

## Step 1: Add a Script to the Repository

Create a simple **shell script** in the repository.

**test.sh**

```bash
#!/bin/bash

echo "Running CI test..."

a=10
b=10

if [ $a -eq $b ]; then
  echo "Test Passed"
else
  echo "Test Failed"
  exit 1
fi
```

---

## Step 2: Create a Workflow

Create the file:

```
.github/workflows/run-tests.yml
```

Workflow example:

```yaml
name: Run Tests in CI

on:
  push:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Make script executable
        run: chmod +x test.sh

      - name: Run Test Script
        run: ./test.sh
```

---

## Step 3: Break the Script (Pipeline Should Fail)

Modify the script:

```bash
a=10
b=20
```

Now the condition fails and the script runs:

```
exit 1
```

Result:
- ❌ GitHub Actions pipeline becomes **red (failed)**.

---

## Step 4: Fix the Script

Change it back:

```bash
a=10
b=10
```

Push again.

Result:
- ✅ Pipeline becomes **green (passed)**.

---

## Key Learning

- CI pipelines should run **real tests instead of dummy commands**.
- If a script returns a **non-zero exit code**, the pipeline fails.
- Fixing the issue makes the pipeline pass again.
- This ensures only **working code moves forward in the pipeline**.





### Task 6: Caching

#### Objective
Use caching in GitHub Actions to speed up dependency installation by reusing previously downloaded files.

---

## Step 1: Add Cache to Workflow

Example using **Python dependencies (pip)**:

```yaml
name: Cache Example

on:
  push:

jobs:
  cache-demo:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.10"

      - name: Cache pip dependencies
        uses: actions/cache@v4
        with:
          path: ~/.cache/pip
          key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
          restore-keys: |
            ${{ runner.os }}-pip-

      - name: Install Dependencies
        run: pip install -r requirements.txt
```

---

## Step 2: Run Workflow Twice

### First Run
- Dependencies are downloaded from the internet
- Takes more time ⏳

### Second Run
- Dependencies are restored from cache
- Much faster ⚡

---

## Step 3: Observation

You will notice:
- First run → slower (no cache)
- Second run → faster (cache hit)

---

## What is being cached?

- Downloaded dependencies (e.g., Python packages)
- Stored in:
```
~/.cache/pip
```

---

## Where is it stored?

- Cached data is stored by **GitHub Actions on their servers**
- It is linked to:
  - Repository
  - Cache key
  - Branch (sometimes)

---

## Why caching is useful?

- Speeds up CI pipelines 🚀
- Reduces repeated downloads 🌐
- Saves time and resources ⏱️

---

## Key Learning

- `actions/cache` helps reuse dependencies between runs.
- Cache is identified using a **key**.
- If the key matches → cache is restored.
- If not → new cache is created.