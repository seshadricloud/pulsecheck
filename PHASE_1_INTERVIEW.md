# Phase 1: Application Development & Containerization - Interview Format

## Interview Transcript

**Interviewer:** Tell me about the project you built in Phase 1. What was the main goal?

**You:** The main goal of Phase 1 was to build a simple but functional microservice and ensure it could run consistently across any machine. We wanted to prove two key things: first, that the application works and can deliver health status information, and second, that it's containerized with Docker so developers don't need to worry about their local environment setup.

**Interviewer:** What did you decide to call this service?

**You:** We called it PulseCheck. The name makes sense because it's essentially checking the pulse—the health—of the service. It exposes a `/health` endpoint that returns a JSON response with information like the service status, version, hostname, and timestamp.

**Interviewer:** Can you describe what that response looks like?

**You:** Sure. When you hit the `/health` endpoint, you get back a JSON object that looks like this:

```json
{
  "status": "healthy",
  "service": "pulsecheck",
  "version": "0.1.0",
  "hostname": "DESKTOP-1VB1F2O",
  "timestamp": "2026-07-04T19:06:20.585373+00:00"
}
```

It gives you the current status, the service name, the version we're running, what machine it's on, and the exact time it checked. This way, you can always verify the service is up and running.

**Interviewer:** What technology stack did you choose for building this?

**You:** We went with Python for the language, FastAPI for the web framework, and Uvicorn as the application server. We also used Pytest for testing and Docker for containerization. FastAPI was a natural choice because it's lightweight, fast, and incredibly simple to use for building REST APIs. It handles a lot of the boilerplate for you.

**Interviewer:** Why not use something heavier like Django?

**You:** For a microservice like this, Django would be overkill. Django is built for larger, monolithic applications with built-in admin panels, ORM complexity, and a lot of batteries included. For a simple health-check endpoint, FastAPI gives us just what we need—no bloat, minimal dependencies, and it starts up quickly.

**Interviewer:** Walk me through the project structure. What files did you create?

**You:** The core structure is pretty straightforward. We have an `app` folder with `main.py` that contains the FastAPI application. Then we have a `tests` folder with `test_main.py` for our unit tests. We have two requirements files—one for runtime dependencies and one for development and testing dependencies. Then we have the Dockerfile to containerize everything, and a `.dockerignore` file to keep the image clean.

**Interviewer:** What's in the `main.py` file?

**You:** That's where the FastAPI application lives. We defined two endpoints: a root `/` endpoint that provides basic service information, and the `/health` endpoint that returns the detailed health status. The `/health` endpoint specifically returns the service status, the service name, the application version, the hostname it's running on, and the current UTC timestamp.

**Interviewer:** And the tests? What were you testing for?

**You:** We wrote tests to verify three key things. First, that the `/health` endpoint returns an HTTP 200 status code. Second, that it actually returns `"status": "healthy"` in the response. And third, that the root `/` endpoint returns the expected health endpoint path. It's basic but important—you want to catch any regressions early.

**Interviewer:** Let's talk about the requirements files. Why do you have two separate files?

**You:** Good question. The `requirements.txt` file contains only the runtime dependencies that the application needs to run in production—FastAPI and Uvicorn. The `requirements-dev.txt` file contains everything in `requirements.txt` plus the development tools we need, like Pytest and HTTPx for testing. This way, when we're building the Docker image for production, we only install what we actually need. It keeps the image smaller and reduces the attack surface.

**Interviewer:** How do you run the application locally without Docker?

**You:** First, I navigate to the project directory. Then I install the development dependencies with `pip install -r requirements-dev.txt`. After that, I start the application using Uvicorn with:

```bash
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The `--reload` flag is useful during development because it automatically restarts the server when you make code changes. The `--host 0.0.0.0` makes it accessible from other machines on the network, and `--port 8000` is where we're running it.

**Interviewer:** And how do you test it locally?

**You:** I just run `python -m pytest -q`. It's quick and quiet. When everything passes, you see `2 passed`, which means both our test cases ran successfully. That gives me confidence that the health endpoint is working as expected.

**Interviewer:** Now let's talk about Docker. Why was containerization important for this project?

**You:** Containerization was critical because the assignment specifically required that the application runs identically on any engineer's machine regardless of their local OS setup. Without Docker, you'd have to ensure everyone has Python 3.x installed, the right version of FastAPI, Uvicorn, and all the dependencies. Someone on Windows might run into issues that someone on macOS doesn't encounter. Docker eliminates all that friction. We package everything—the Python runtime, all dependencies, the application code, and the startup command—into a single image. Then anyone with Docker can run it exactly the same way on Windows, macOS, or Linux.

**Interviewer:** How do you build the Docker image?

**You:** Very simple:

```bash
docker build -t pulsecheck:local .
```

This command tells Docker to build an image using the Dockerfile in the current directory and tag it as `pulsecheck:local`. The `local` tag helps me distinguish development images from any production images we might create later.

**Interviewer:** What's in the Dockerfile?

**You:** The Dockerfile starts with a Python base image, installs the application dependencies from `requirements.txt`, copies the application code into the image, exposes port 8000, and then starts the FastAPI app using Uvicorn. It's a fairly standard pattern for Python applications.

**Interviewer:** Why do you have a `.dockerignore` file?

**You:** Just like `.gitignore`, `.dockerignore` tells Docker what to exclude when building the image. We don't want unnecessary files like `.git` directories, local caches, or development artifacts being copied into the Docker image. It keeps the image smaller and cleaner.

**Interviewer:** Once you've built the image, how do you run it?

**You:** I use:

```bash
docker run --rm -p 8000:8000 pulsecheck:local
```

The `--rm` flag automatically cleans up the container when it stops running. The `-p 8000:8000` maps port 8000 on my local machine to port 8000 inside the container. And then I just specify the image name, `pulsecheck:local`.

**Interviewer:** Once it's running, how do you verify it's working?

**You:** I open a browser and navigate to `http://localhost:8000/health`. If I see that JSON response with `"status": "healthy"`, I know it's working. I can also check the Docker logs, and I'd see something like:

```
INFO:     Uvicorn running on http://0.0.0.0:8000
INFO:     127.0.0.1:43050 - "GET /health HTTP/1.1" 200 OK
```

That 200 OK response tells me the endpoint is responding correctly.

**Interviewer:** So how does this actually satisfy the requirement that the application runs identically on any machine?

**You:** Because everything is packaged into the Docker image. Another developer doesn't need to configure Python, install packages manually, or worry about version conflicts. They just need Docker installed. They can clone the repo, run `docker build -t pulsecheck:local .`, then `docker run --rm -p 8000:8000 pulsecheck:local`, and they'll get the exact same behavior on their machine—whether it's Windows, macOS, or Linux. The operating system doesn't matter anymore.

**Interviewer:** What proof do you have that Phase 1 is complete?

**You:** I have several pieces of evidence. First, the `/health` endpoint returns the healthy JSON response we designed. Second, our unit tests pass—2 passed. Third, the Docker container starts without errors. Fourth, the containerized app responds to requests to `/health` with an HTTP 200 OK status. And the Docker logs confirm that Uvicorn is running and handling requests correctly. All of these together prove that the service works both locally and in a container.

**Interviewer:** If you had to give a quick summary for a demo, what would you say?

**You:** I'd say something like: "In Phase 1, I built a lightweight Python FastAPI application called PulseCheck that exposes a `/health` endpoint returning a JSON response with the service status, version, hostname, and timestamp. I added unit tests to verify the endpoint works correctly. And to ensure the application runs consistently across any machine, I containerized it with Docker. The Dockerfile packages all dependencies and the application code, so any developer can run it identically regardless of their OS or local setup—they just need Docker installed."

**Interviewer:** And Phase 1 is now complete?

**You:** Yes, Phase 1 is complete. The service works, it's tested, and it's containerized.

---

## Summary of Key Points (For Reference)

- **Service Name:** PulseCheck
- **Main Endpoint:** `/health` (returns JSON with status, service name, version, hostname, timestamp)
- **Tech Stack:** Python, FastAPI, Uvicorn, Pytest, Docker
- **Project Files:** app/main.py, tests/test_main.py, requirements.txt, requirements-dev.txt, Dockerfile, .dockerignore
- **Local Development:** Install deps → Run Uvicorn → Access http://localhost:8000/health
- **Testing:** `python -m pytest -q` (expects 2 passed)
- **Containerization:** `docker build -t pulsecheck:local .` → `docker run --rm -p 8000:8000 pulsecheck:local`
- **Why Containerization:** Ensures identical behavior across Windows, macOS, and Linux
- **Phase 1 Proof:** Working health endpoint + passing tests + successful Docker build and run
