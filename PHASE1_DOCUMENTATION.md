# Phase 1: Application Development & Containerization

## 1. Purpose of Phase 1

Phase 1 is about building a small health-check microservice and making sure it can run in the same way on any machine.

The goal is to prove two things:

1. The application works and returns a health status.
2. The application is containerized with Docker so it does not depend on a developer's local setup.

In this project, the service is called **PulseCheck**.

PulseCheck exposes a `/health` endpoint that returns a JSON response showing whether the service is healthy.

Example response:

```json
{
  "status": "healthy",
  "service": "pulsecheck",
  "version": "0.1.0",
  "hostname": "DESKTOP-1VB1F2O",
  "timestamp": "2026-07-04T19:06:20.585373+00:00"
}
```

## 2. Application Technology

The application is built using:

- **Python** as the programming language
- **FastAPI** as the web framework
- **Uvicorn** as the application server
- **Pytest** for testing
- **Docker** for containerization

FastAPI was selected because it is lightweight, fast, and simple to use for building REST APIs.

## 3. Project Files Used in Phase 1

```text
PulseCheck
|
|-- app/
|   |-- main.py
|
|-- tests/
|   |-- test_main.py
|
|-- requirements.txt
|
|-- requirements-dev.txt
|
|-- Dockerfile
|
|-- .dockerignore
```

### `app/main.py`

This file contains the FastAPI application.

It defines:

- `/` endpoint for basic service information
- `/health` endpoint for health-check status

The `/health` endpoint returns:

- service status
- service name
- application version
- hostname
- current UTC timestamp

### `tests/test_main.py`

This file contains unit tests for the application.

The tests verify:

- `/health` returns HTTP `200`
- `/health` returns `"status": "healthy"`
- `/` returns the expected health endpoint path

### `requirements.txt`

This file contains the runtime dependencies needed by the application:

```text
fastapi
uvicorn
```

### `requirements-dev.txt`

This file contains development and testing dependencies:

```text
pytest
httpx
```

### `Dockerfile`

This file defines how to package the application into a Docker image.

It:

1. Starts from a Python base image.
2. Installs the application dependencies.
3. Copies the application code into the image.
4. Exposes port `8000`.
5. Starts the FastAPI app using Uvicorn.

### `.dockerignore`

This file prevents unnecessary local files from being copied into the Docker image.

## 4. Running the App Locally Without Docker

First, go to the project folder:

```bash
cd /c/Users/reddy/Documents/PulseCheck
```

Install dependencies:

```bash
python -m pip install -r requirements-dev.txt
```

Start the application:

```bash
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Open this URL in the browser:

```text
http://localhost:8000/health
```

Expected result:

```json
{
  "status": "healthy",
  "service": "pulsecheck",
  "version": "0.1.0",
  "hostname": "...",
  "timestamp": "..."
}
```

This confirms that the Python application is working locally.

## 5. Running Unit Tests

Run:

```bash
python -m pytest -q
```

Expected result:

```text
2 passed
```

This confirms that the basic application behavior is tested successfully.

## 6. Building the Docker Image

Docker is used to containerize the application.

Build the image:

```bash
docker build -t pulsecheck:local .
```

Meaning of the command:

- `docker build` creates a Docker image.
- `-t pulsecheck:local` gives the image a name and tag.
- `.` tells Docker to use the current project directory as the build context.

After the build completes, Docker has a reusable image of the PulseCheck service.

## 7. Running the Docker Container

Run the container:

```bash
docker run --rm -p 8000:8000 pulsecheck:local
```

Meaning of the command:

- `docker run` starts a container.
- `--rm` removes the container after it stops.
- `-p 8000:8000` maps local port `8000` to container port `8000`.
- `pulsecheck:local` is the Docker image name.

Open:

```text
http://localhost:8000/health
```

If the browser returns the healthy JSON response, the application is successfully running inside Docker.

## 8. How Containerization Satisfies the Requirement

The assignment asks:

> Ensure the application is fully containerized so that it runs identically on any engineer's machine regardless of their local OS setup.

This is satisfied because Docker packages:

- the Python runtime
- Python dependencies
- application code
- startup command
- exposed port

So another engineer does not need to manually configure the same Python environment. They only need Docker installed.

They can run:

```bash
docker build -t pulsecheck:local .
docker run --rm -p 8000:8000 pulsecheck:local
```

The application will run the same way on Windows, macOS, or Linux.

## 9. Phase 1 Proof

The following results prove Phase 1 is complete:

1. The `/health` endpoint returns a healthy JSON response.
2. Unit tests pass with `2 passed`.
3. Docker container starts successfully.
4. The containerized app responds to `/health` with HTTP `200 OK`.

Example Docker log:

```text
INFO:     Uvicorn running on http://0.0.0.0:8000
INFO:     127.0.0.1:43050 - "GET /health HTTP/1.1" 200 OK
```

## 10. Demo Explanation Script

Use this explanation during your demo:

> In Phase 1, I built a lightweight Python FastAPI application called PulseCheck. The application exposes a `/health` endpoint that returns a JSON response with the service status, service name, version, hostname, and timestamp.
>
> I also added unit tests to verify that the health endpoint returns a successful response and the expected status.
>
> To make the application portable, I containerized it using Docker. The Dockerfile installs the required dependencies, copies the application code, exposes port 8000, and starts the service using Uvicorn.
>
> This means the application can run consistently on any engineer's machine as long as Docker is installed, regardless of the local operating system or Python setup.

## 11. Phase 1 Status

Phase 1 is complete.

Completed items:

- Python FastAPI health-check application
- `/health` JSON endpoint
- Basic unit tests
- Dockerfile
- Docker image build
- Docker container run
- Health endpoint verified from container
