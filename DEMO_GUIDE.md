# 🎬 PulseCheck Video Demonstration Guide

A structured script for recording and explaining the PulseCheck local deployment.

---

## **Part 1: Introduction (30 seconds)**

### What to Say:
> "Hello! Today I'm demonstrating PulseCheck, a lightweight health-monitoring microservice. It's built with Python FastAPI and designed to be cloud-ready. Let me show you how to run it locally."

### What to Show:
- Show the GitHub repository page
- Point out: Python language, recent activity, project description

---

## **Part 2: Project Structure (30 seconds)**

### What to Show:
- Open the repository in your code editor
- Navigate through the main folders:
  - `app/` - Application code
  - `tests/` - Test files
  - `infra/` - Infrastructure templates
  - `.github/workflows/` - CI/CD pipeline

### What to Say:
> "The project is well-organized. The app folder contains our FastAPI service, tests folder has our unit tests, and infra contains our deployment templates."

---

## **Part 3: Setup & Installation (1 minute)**

### What to Do Step-by-Step:

1. **Open Terminal**
```bash
cd path/to/pulsecheck
```

2. **Show the requirements file**
```bash
cat requirements-dev.txt
```

3. **Install dependencies**
```bash
pip install -r requirements-dev.txt
```

### What to Say:
> "First, we install the development dependencies. This includes FastAPI, Uvicorn for the web server, and pytest for testing."

---

## **Part 4: Run Tests (45 seconds)**

### What to Do:

```bash
pytest -q
```

### What to Say:
> "Let's run the unit tests to make sure everything is working correctly. The pytest command runs all tests in the tests folder."

### Expected Output:
```
... passed
```

---

## **Part 5: Start the Application (1 minute)**

### What to Do:

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### What to Say:
> "Now I'm starting the FastAPI application using Uvicorn. The `--reload` flag enables hot-reloading for development, and it's running on port 8000. The application is now ready to receive requests."

### Expected Output:
```
INFO:     Uvicorn running on http://0.0.0.0:8000
```

---

## **Part 6: Test the Health Endpoint (1 minute)**

### What to Do in a New Terminal:

```bash
curl http://localhost:8000/health
```

Or open in browser:
```
http://localhost:8000/health
```

### What to Say:
> "Here we're calling the `/health` endpoint. The service returns its status, version number, hostname, and a timestamp. This is exactly what a monitoring system would check to verify the service is running."

### Expected Response:
```json
{
  "status": "healthy",
  "service": "pulsecheck",
  "version": "0.1.0",
  "hostname": "your-hostname",
  "timestamp": "2026-07-06T12:00:00+00:00"
}
```

---

## **Part 7: Show the Code (1 minute)**

### What to Show:

Open `app/main.py` and explain:

```python
@app.get("/health")
async def health():
    return {
        "status": "healthy",
        "service": "pulsecheck",
        "version": "0.1.0",
        "hostname": socket.gethostname(),
        "timestamp": datetime.now(timezone.utc).isoformat()
    }
```

### What to Say:
> "This is the core of our service. The `/health` endpoint is a simple FastAPI route that returns the service status. It's lightweight, fast, and follows cloud-native best practices."

---

## **Part 8: Close-up & Summary (30 seconds)**

### What to Say:
> "That's PulseCheck running locally! In production, this service would be containerized with Docker and deployed on AWS ECS Fargate behind a load balancer. The same health endpoint would be used for automated health checks to ensure the service is always running."

---

## 📹 Recording Tips

### Software:
- **Mac:** QuickTime
- **Windows:** OBS Studio or Xbox Game Bar
- **Linux:** OBS Studio or SimpleScreenRecorder

### Best Practices:
1. Speak clearly and pause between sections
2. Adjust terminal font size for readability
3. Use a quality microphone for clear audio
4. Keep the video 5-7 minutes total
5. Add titles/captions (optional but professional)

### Suggested Title Slides:
- "PulseCheck Demo"
- "Local Setup"
- "Running Tests"
- "Starting Service"
- "Testing Endpoint"

---

## 📤 Sharing the Video

### Format:
- **MP4** format (most compatible)
- Resolution: **1080p or higher**

### Platforms:
- YouTube (private or unlisted)
- Google Drive
- Dropbox
- Email (if file size allows)

---

## 📋 Quick Checklist

- [ ] Repository cloned and ready
- [ ] Terminal font size increased (readable on video)
- [ ] Dependencies installed
- [ ] Tests passing locally
- [ ] Screen recording software configured
- [ ] Microphone tested
- [ ] Application runs without errors
- [ ] Health endpoint responds correctly
- [ ] Code editor ready to show main.py
- [ ] Video saved in MP4 format
- [ ] Video uploaded to sharing platform

---

## 🎥 Total Video Duration: 5-7 minutes

| Section | Duration |
|---------|----------|
| Introduction | 30 sec |
| Project Structure | 30 sec |
| Setup & Installation | 1 min |
| Run Tests | 45 sec |
| Start Application | 1 min |
| Test Endpoint | 1 min |
| Show Code | 1 min |
| Summary | 30 sec |
| **Total** | **~6 min** |

---

Good luck with your demonstration! 🚀
