# PulseCheck

PulseCheck is a lightweight Python health-monitoring microservice built for the DevOps screening assignment. It exposes a simple HTTP health endpoint, runs inside Docker, includes an automated CI pipeline, and provides AWS CloudFormation infrastructure for deployment on ECS Fargate.

Repository: https://github.com/seshadricloud/pulsecheck.git

## Project Overview

The goal of this project is to show a complete DevOps workflow for a small service:

1. Build a Python web service that reports health status.
2. Containerize the service so it runs the same way on any machine.
3. Add a CI/CD pipeline that runs tests, builds the Docker image, and simulates deployment.
4. Define cloud infrastructure using Infrastructure as Code.

## Tech Stack

| Area | Tool |
| --- | --- |
| Application | Python 3.12, FastAPI |
| Web server | Uvicorn |
| Testing | Pytest, FastAPI TestClient |
| Containerization | Docker |
| CI/CD | GitHub Actions |
| Infrastructure as Code | AWS CloudFormation |
| Cloud target | Amazon ECS Fargate with Application Load Balancer |

## Folder Structure

```text
.
|-- app/
|   `-- main.py
|-- tests/
|   `-- test_main.py
|-- scripts/
|   |-- simulate_deploy.sh
|   `-- simulate_deploy.ps1
|-- infra/
|   `-- cloudformation/
|       `-- pulsecheck-ecs-fargate.yml
|-- .github/
|   `-- workflows/
|       `-- ci.yml
|-- Dockerfile
|-- requirements.txt
|-- requirements-dev.txt
`-- README.md
```

## API Endpoints

### Root Endpoint

```http
GET /
```

Returns basic service information and points users to the health endpoint.

Example response:

```json
{
  "service": "pulsecheck",
  "message": "PulseCheck health-monitoring service",
  "health_url": "/health"
}
```

### Health Endpoint

```http
GET /health
```

Returns the current health status of the service.

Example response:

```json
{
  "status": "healthy",
  "service": "pulsecheck",
  "version": "0.1.0",
  "hostname": "container-hostname",
  "timestamp": "2026-07-04T10:00:00+00:00"
}
```

Response fields:

| Field | Meaning |
| --- | --- |
| `status` | Current health status of the service |
| `service` | Service name, default is `pulsecheck` |
| `version` | Application version, default is `0.1.0` |
| `hostname` | Hostname of the machine or container serving the request |
| `timestamp` | Current UTC timestamp in ISO format |

## Run Locally

### 1. Create a Virtual Environment

```bash
python -m venv .venv
```

Activate it on Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

Activate it on macOS or Linux:

```bash
source .venv/bin/activate
```

### 2. Install Dependencies

```bash
pip install -r requirements-dev.txt
```

### 3. Run Tests

```bash
pytest -q
```

Expected result:

```text
2 passed
```

### 4. Start the Application

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Open the health endpoint:

```text
http://localhost:8000/health
```

Or test it from the terminal:

```bash
curl http://localhost:8000/health
```

## Run With Docker

### 1. Build the Image

```bash
docker build -t pulsecheck:local .
```

### 2. Run the Container

```bash
docker run --rm -p 8000:8000 pulsecheck:local
```

### 3. Test the Container

```bash
curl http://localhost:8000/health
```

The Dockerfile also includes a container health check that calls `/health` internally.

## CI/CD Pipeline

The GitHub Actions workflow is defined in:

```text
.github/workflows/ci.yml
```

It runs on:

- Pushes to the `main` branch
- Pull requests

Pipeline steps:

1. Check out the repository.
2. Set up Python 3.12.
3. Install development dependencies.
4. Run unit tests with `pytest`.
5. Build the Docker image.
6. Run a simulated deployment script.

The deployment step is simulated so the project can be reviewed without requiring AWS credentials in GitHub Actions.

## Simulate Deployment Locally

On macOS or Linux:

```bash
./scripts/simulate_deploy.sh pulsecheck:local
```

On Windows PowerShell:

```powershell
.\scripts\simulate_deploy.ps1 -ImageTag pulsecheck:local
```

Expected output:

```text
Simulating deployment for image: pulsecheck:local
Deployment target: AWS ECS Fargate service defined in infra/cloudformation/pulsecheck-ecs-fargate.yml
Result: success
```

## AWS Infrastructure

The CloudFormation template is located at:

```text
infra/cloudformation/pulsecheck-ecs-fargate.yml
```

It provisions:

- ECS cluster
- ECS Fargate task definition
- ECS service
- Application Load Balancer
- Target group using `/health` as the health check path
- Security groups for the load balancer and service
- CloudWatch log group
- ECS task execution IAM role

This architecture is suitable for a lightweight containerized service because ECS Fargate removes the need to manage servers while still supporting Docker-based deployments.

## Cloud Deployment Flow

To deploy this service to AWS:

1. Create an Amazon ECR repository.
2. Build the Docker image.
3. Push the image to ECR.
4. Deploy the CloudFormation stack with the ECR image URI, VPC ID, and public subnet IDs.
5. Use the `ServiceUrl` stack output to access `/health`.

Example deployment command:

```bash
aws cloudformation deploy \
  --template-file infra/cloudformation/pulsecheck-ecs-fargate.yml \
  --stack-name pulsecheck \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
    ImageUri=<account-id>.dkr.ecr.<region>.amazonaws.com/pulsecheck:latest \
    VpcId=<vpc-id> \
    PublicSubnetIds=<subnet-a>,<subnet-b>
```

After deployment, CloudFormation outputs the service URL:

```text
http://<load-balancer-dns-name>/health
```

## How This Meets the Assignment

### Phase 1: Application Development and Containerization

- The application is written in Python using FastAPI.
- The `/health` endpoint returns a JSON health response.
- The Dockerfile packages the application into a portable container.
- The same container can run locally or in AWS ECS Fargate.

### Phase 2: CI/CD Automation

- GitHub Actions runs automatically on push and pull request events.
- The pipeline installs dependencies, runs tests, builds the Docker image, and simulates deployment.
- The simulated deployment step demonstrates the delivery process without requiring cloud credentials.

### Phase 3: Infrastructure as Code

- AWS infrastructure is defined using CloudFormation.
- The selected target architecture is ECS Fargate behind an Application Load Balancer.
- The template defines compute, networking access, load balancing, logging, and IAM execution permissions.

## Useful Commands

| Task | Command |
| --- | --- |
| Install dependencies | `pip install -r requirements-dev.txt` |
| Run tests | `pytest -q` |
| Start app locally | `uvicorn app.main:app --reload --host 0.0.0.0 --port 8000` |
| Build Docker image | `docker build -t pulsecheck:local .` |
| Run Docker container | `docker run --rm -p 8000:8000 pulsecheck:local` |
| Test health endpoint | `curl http://localhost:8000/health` |
| Simulate deployment on Linux/macOS | `./scripts/simulate_deploy.sh pulsecheck:local` |
| Simulate deployment on Windows | `.\scripts\simulate_deploy.ps1 -ImageTag pulsecheck:local` |

## Submission Checklist

- GitHub repository link
- Passing GitHub Actions workflow screenshot
- Local test execution screenshot
- Docker build screenshot
- Docker container running screenshot
- `/health` endpoint response screenshot
- Optional AWS ECS Fargate service URL if deployed

## Summary

PulseCheck demonstrates the core DevOps lifecycle for a small production-style service: application development, automated testing, containerization, CI/CD automation, and Infrastructure as Code. It can be reviewed locally through Docker and GitHub Actions, and it is ready to be deployed to AWS ECS Fargate when cloud credentials are available.
