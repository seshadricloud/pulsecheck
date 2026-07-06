param(
    [string]$ImageTag = "pulsecheck:local"
)

Write-Host "Simulating deployment for image: $ImageTag"
Write-Host "Deployment target: AWS ECS Fargate service defined in infra/cloudformation/pulsecheck-ecs-fargate.yml"
Write-Host "Result: success"