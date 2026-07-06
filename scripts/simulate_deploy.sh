#!/usr/bin/env sh
set -eu

IMAGE_TAG="${1:-pulsecheck:local}"

echo "Simulating deployment for image: ${IMAGE_TAG}"
echo "Deployment target: AWS ECS Fargate service defined in infra/cloudformation/pulsecheck-ecs-fargate.yml"
echo "Result: success"