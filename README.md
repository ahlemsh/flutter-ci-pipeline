# flutter-ci-pipeline

CI/CD pipeline for a Flutter mobile app with a Python backend, fully containerized with Docker and automated via Bitbucket Pipelines.

## Pipeline Overview

```
Bitbucket Pipeline
       ↓
docker compose build
       ↓
┌─────────────────────┬──────────────────────┐
│  Flutter CI Image   │   Backend CI Image   │
│ safedocs-flutter-ci │ safedocs-backend-ci  │
│      :3.47.2        │        :dev          │
└─────────────────────┴──────────────────────┘
       ↓                        ↓
  Flutter analyze          Python compile
  Flutter tests (28)       pytest (12 tests)
  Build APK (debug)
       ↓
  APK artifact
  docker-output/safedocs-dev.apk
```

## Results

### Flutter
- ✅ 28 tests passed
- ✅ Static analysis executed (`flutter analyze`)
- ✅ Debug APK built inside Docker and exported as artifact

### Backend
- ✅ Python compilation check (`compileall`)
- ✅ 12 tests passed
  - 10 unit tests
  - 2 integration tests

### Docker
- ✅ `safedocs-flutter-ci:3.47.2` image built
- ✅ `safedocs-backend-ci:dev` image built
- ✅ `docker compose` configuration validated

## Project Structure

```
.
├── Dockerfile                  # Flutter CI image (Android SDK + Flutter 3.47.2)
├── docker-compose.yml          # Orchestrates Flutter CI + Backend CI containers
├── bitbucket-pipelines.yml     # Bitbucket CI/CD pipeline definition
├── .dockerignore
└── backend/
    └── Dockerfile              # Python 3.13 backend image
```

## Flutter CI Image

Built on top of `ghcr.io/cirruslabs/android-sdk:36`, the image includes:
- Java 17 (OpenJDK)
- Android SDK (platforms 34 & 35, build-tools 34.0.0, NDK 27)
- Flutter 3.47.2 (cloned from official repo)

## Pipeline Steps (Bitbucket)

The custom pipeline `safedocs-ci` runs on a 2x runner with Docker-in-Docker:

1. **Build images** — `docker compose build`
2. **Backend tests** — `docker compose run --rm backend`
3. **Flutter CI** — analyze + test + build APK via `docker compose run --rm flutter-ci`
4. **Artifact** — APK exported to `docker-output/` and saved as pipeline artifact

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile | Flutter 3.47.2 / Dart |
| Backend | Python 3.13 / FastAPI / uvicorn |
| Containerization | Docker / Docker Compose |
| CI/CD | Bitbucket Pipelines |
| Android Build | Android SDK 34/35, NDK 27 |
