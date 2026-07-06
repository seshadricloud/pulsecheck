# PulseCheck Microservice

PulseCheck is a lightweight health-monitoring microservice. It exposes a simple HTTP endpoint that reports service health and is packaged for repeatable deployment with Docker, GitHub Actions, and AWS CloudFormation.

## Architecture

- **Application:** Python FastAPI service
- **Container:** Docker image running Uvicorn on port `8000`
- **CI/CD:** GitHub Actions pipeline for tests, image build, and simulated deployment
- **Infrastructure:** AWS CloudFormation template for ECS Fargate behind an Application Load Balancer

## API

`GET /health`

Example response:

json
{
  "status": "healthy",
  "service": "pulsecheck",
  "version": "0.1.0",
  "hostname": "container-hostname",
  "timestamp": "2026-07-04T10:00:00+00:00"
}


## Run Locally

Install dependencies:

bash
pip install -r requirements-dev.txt


Run tests:

bash
pytest -q


Start the app:

bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000


Check the health endpoint:

bash
curl http://localhost:8000/health


## Run With Docker

Build the image:

bash
docker build -t pulsecheck:local .


Run the container:

bash
docker run --rm -p 8000:8000 pulsecheck:local


Open:

text
http://localhost:8000/health


## CI/CD Pipeline

The GitHub Actions workflow in `.github/workflows/ci.yml` runs on every push to `main` and on pull requests.

Pipeline stages:

1. Install Python dependencies
2. Run unit tests
3. Build the Docker image
4. Simulate deployment

The simulated deployment step keeps the assignment demonstrable without requiring AWS credentials in CI.

## AWS Cloud Deployment

The CloudFormation template is located at:

text
infra/cloudformation/pulsecheck-ecs-fargate.yml


It provisions:

- ECS cluster
- Fargate task definition
- ECS service
- Application Load Balancer
- Target group with `/health` health checks
- Security groups
- CloudWatch log group
- ECS task execution role

High-level deployment flow:

1. Create an ECR repository.
2. Build and push the Docker image to ECR.
3. Deploy the CloudFormation stack with the image URI, VPC ID, and public subnet IDs.
4. Use the `ServiceUrl` stack output to test the running service.

Example CloudFormation command:

bash
aws cloudformation deploy \
  --template-file infra/cloudformation/pulsecheck-ecs-fargate.yml \
  --stack-name pulsecheck \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
    ImageUri=<account-id>.dkr.ecr.<region>.amazonaws.com/pulsecheck:latest \
    VpcId=<vpc-id> \
    PublicSubnetIds=<subnet-a>,<subnet-b>


## Submission Checklist

- GitHub repository containing application, Dockerfile, CI/CD workflow, and CloudFormation template
- Screenshot of GitHub Actions pipeline passing
- Screenshot of Docker container running locally
- Screenshot or short recording of `/health` returning a healthy JSON response
- Optional live AWS endpoint if deployed to ECS Fargate
