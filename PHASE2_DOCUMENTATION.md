# Phase 2: CI/CD Automation

## 1. Purpose of Phase 2

Phase 2 is about automating the delivery process.

The assignment asks for an automated pipeline script stored in the repository that runs every time code is pushed.

The pipeline must handle:

1. Running basic syntax checks or unit tests on the Python code.
2. Building the Docker container image.
3. Simulating a deployment step.

In this project, CI/CD automation is implemented using **GitHub Actions**.

## 2. What CI/CD Means

CI/CD means **Continuous Integration and Continuous Delivery/Deployment**.

### Continuous Integration

Continuous Integration checks whether the code is still working after every change.

For this project, CI runs the Python tests.

### Continuous Delivery or Deployment

Continuous Delivery prepares the application for deployment.

For this project, the pipeline builds a Docker image and runs a simulated deployment step.

The deployment is simulated because actual AWS deployment requires cloud credentials, ECR setup, VPC details, and permissions. The simulation still proves the deployment stage exists in the pipeline.

## 3. Pipeline File

The pipeline is stored in:

```text
.github/workflows/ci.yml
```

This file is part of the repository, so GitHub can automatically detect and run it.

## 4. Pipeline Trigger

The workflow starts automatically when code is pushed to the `main` branch:

```yaml
on:
  push:
    branches:
      - main
  pull_request:
```

This satisfies the requirement:

> Create an automated pipeline script that triggers every time code is pushed.

It also runs on pull requests, which is useful for validating changes before merging.

## 5. Pipeline Stages

The pipeline contains one job:

```yaml
jobs:
  test-build-deploy:
    runs-on: ubuntu-latest
```

This means GitHub Actions will run the job on a fresh Ubuntu Linux runner.

## 6. Stage 1: Checkout Repository

```yaml
- name: Checkout repository
  uses: actions/checkout@v4
```

This downloads the repository code into the GitHub Actions runner.

Without this step, the pipeline would not have access to the application files.

## 7. Stage 2: Set Up Python

```yaml
- name: Set up Python
  uses: actions/setup-python@v5
  with:
    python-version: "3.12"
```

This installs Python 3.12 in the CI environment.

It ensures the pipeline runs the application with a known Python version.

## 8. Stage 3: Install Dependencies

```yaml
- name: Install dependencies
  run: pip install -r requirements-dev.txt
```

This installs all dependencies needed for testing.

`requirements-dev.txt` includes:

- FastAPI
- Uvicorn
- Pytest
- HTTPX

## 9. Stage 4: Run Unit Tests

```yaml
- name: Run unit tests
  run: pytest -q
```

This runs the Python test suite.

The project has tests in:

```text
tests/test_main.py
```

The tests verify:

- `/health` returns HTTP `200`
- `/health` returns `"status": "healthy"`
- `/` returns the expected health endpoint path

This satisfies the requirement:

> Running basic syntax or unit tests on your Python code.

## 10. Stage 5: Build Container Image

```yaml
- name: Build container image
  run: docker build -t pulsecheck:${{ github.sha }} .
```

This builds a Docker image from the project Dockerfile.

The image tag uses the Git commit SHA:

```text
pulsecheck:<commit-sha>
```

This is useful because every build can be traced back to the exact code commit that produced it.

This satisfies the requirement:

> Building the container image.

## 11. Stage 6: Simulate Deployment

```yaml
- name: Simulate deployment
  run: |
    chmod +x scripts/simulate_deploy.sh
    ./scripts/simulate_deploy.sh pulsecheck:${{ github.sha }}
```

This runs the deployment simulation script:

```text
scripts/simulate_deploy.sh
```

The script prints:

```text
Simulating deployment for image: pulsecheck:<commit-sha>
Deployment target: AWS ECS Fargate service defined in infra/cloudformation/pulsecheck-ecs-fargate.yml
Result: success
```

This satisfies the requirement:

> Simulating a deployment step.

## 12. Why Deployment Is Simulated

In a real production setup, this stage would:

1. Authenticate to AWS.
2. Push the Docker image to Amazon ECR.
3. Update the ECS Fargate service.
4. Wait for the new deployment to become healthy.

For this assignment, the deployment step is simulated to show the pipeline structure without requiring AWS secrets in the repository.

This is safer because AWS credentials should never be committed to GitHub.

## 13. Local Deployment Simulation

You can also run the deployment simulation manually.

On Git Bash:

```bash
./scripts/simulate_deploy.sh pulsecheck:local
```

On PowerShell:

```powershell
.\scripts\simulate_deploy.ps1 -ImageTag pulsecheck:local
```

Expected output:

```text
Simulating deployment for image: pulsecheck:local
Deployment target: AWS ECS Fargate service defined in infra/cloudformation/pulsecheck-ecs-fargate.yml
Result: success
```

## 14. Full CI/CD Flow

```text
Developer pushes code to GitHub
        |
        v
GitHub Actions starts automatically
        |
        v
Checkout repository
        |
        v
Set up Python
        |
        v
Install dependencies
        |
        v
Run unit tests
        |
        v
Build Docker image
        |
        v
Simulate deployment
```

## 15. What To Show In Demo

For Phase 2, show:

1. The `.github/workflows/ci.yml` file.
2. The GitHub Actions run triggered after a push.
3. The test step passing.
4. The Docker build step passing.
5. The simulated deployment step showing `Result: success`.

## 16. Demo Explanation Script

Use this explanation during your demo:

> In Phase 2, I implemented CI/CD automation using GitHub Actions. The pipeline is stored in `.github/workflows/ci.yml` and runs automatically whenever code is pushed to the main branch.
>
> The pipeline first checks out the repository, sets up Python 3.12, installs dependencies, and runs the unit tests using Pytest.
>
> After the tests pass, the pipeline builds a Docker image for the PulseCheck application. Finally, it runs a simulated deployment step that represents deploying the image to AWS ECS Fargate using the CloudFormation infrastructure defined in the repository.
>
> This ensures every code push is automatically validated, packaged, and prepared for deployment.

## 17. Phase 2 Status

Phase 2 is complete.

Completed items:

- GitHub Actions workflow added
- Pipeline triggers on push to `main`
- Pipeline also runs on pull requests
- Python dependencies installed in CI
- Unit tests run in CI
- Docker image built in CI
- Deployment step simulated in CI
