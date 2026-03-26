# DevOps Starter - Full DevOps Pipeline

A Node.js application with a **complete DevOps pipeline** demonstrating modern practices from development to production deployment.

![CI/CD](https://github.com/AnassEhab33/devops-starter/actions/workflows/CI.yml/badge.svg)

---

## Architecture

```
Developer → Git Push → GitHub Actions (CI/CD)
                            │
                    ┌───────┴───────┐
                    │               │
                  Tests        Docker Build
                    │               │
                    ▼               ▼
               Jest + DB      Docker Hub / ECR
                                    │
                          ┌─────────┼─────────┐
                          │         │         │
                        Render     AWS ECS   Kubernetes
                        (PaaS)    (Fargate)  (Minikube)
```

## Tech Stack

| Category | Technology |
|----------|-----------|
| **Application** | Node.js, Express.js |
| **Database** | PostgreSQL |
| **Testing** | Jest, Supertest |
| **Containerization** | Docker, Docker Compose |
| **CI/CD** | GitHub Actions, Jenkins |
| **Container Registry** | Docker Hub, AWS ECR |
| **Cloud Deployment** | Render, AWS ECS (Fargate) |
| **Orchestration** | Kubernetes (Minikube) |
| **Infrastructure as Code** | Terraform |

## Project Structure

```
devops-starter/
├── server.js                    # Express.js application
├── server.test.js               # Automated tests (Jest)
├── Dockerfile                   # Container image definition
├── docker-compose.yml           # Multi-container local dev setup
├── Jenkinsfile                  # Jenkins pipeline as code
├── nodemon.json                 # Hot reload config for development
├── package.json                 # Dependencies & scripts
│
├── .github/workflows/
│   └── CI.yml                   # GitHub Actions CI/CD pipeline
│
├── k8s/                         # Kubernetes manifests
│   ├── deployment.yaml          # App deployment (3 replicas)
│   └── service.yaml             # NodePort service (port 30001)
│
├── aws/                         # AWS configuration
│   └── task-definition.json     # ECS Fargate task definition
│
├── terraform/                   # Infrastructure as Code
│   ├── provider.tf              # AWS provider config
│   ├── variables.tf             # Reusable variables
│   ├── main.tf                  # All AWS resources
│   └── outputs.tf               # Output values
│
└── docs/                        # Learning documentation
    ├── 01-nodejs-npm.md
    ├── 02-testing.md
    ├── 03-docker.md
    ├── 04-ci-cd.md
    ├── 05-docker-hub.md
    ├── 06-cloud-deployment.md
    ├── 07-docker-compose.md
    ├── 08-kubernetes.md
    ├── 09-jenkinsfile.md
    ├── 10-aws-deployment.md
    └── 11-terraform.md
```

## CI/CD Pipeline

### GitHub Actions Pipeline

```
Push to main
    │
    ▼
┌──────────────────┐     ┌──────────────────────┐
│   TEST JOB       │     │   BUILD & PUSH JOB   │
│                  │     │                      │
│ • Checkout code  │────▶│ • Checkout code      │
│ • Setup Node 18  │     │ • Login to Docker Hub│
│ • npm install    │     │ • Build Docker image │
│ • npm test       │     │ • Push to registry   │
│ • PostgreSQL DB  │     │                      │
└──────────────────┘     └──────────────────────┘
```

### Jenkins Pipeline

```groovy
pipeline {
    agent any
    stages {
        stage('Install') { steps { sh 'npm install' } }
        stage('Test')    { steps { sh 'npm test' } }
        stage('Build')   { steps { sh 'docker build ...' } }
    }
}
```

## Docker

### Build & Run

```bash
# Build the image
docker build -t devops-starter .

# Run the container
docker run -p 3000:3000 devops-starter
```

### Docker Compose (App + Database)

```bash
# Start app + PostgreSQL
docker-compose up --build

# Hot reload enabled! Edit server.js and see changes live
```

## Kubernetes

```bash
# Deploy to Minikube
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Access the app
minikube service devops-starter-service
```

## AWS Deployment

### ECS (Fargate)

```bash
# Push image to ECR
aws ecr get-login-password | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
docker build -t devops-starter .
docker tag devops-starter:latest <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/devops-starter:latest
docker push <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/devops-starter:latest
```

### Terraform (Infrastructure as Code)

```bash
cd terraform

# Preview infrastructure changes
terraform plan

# Create all AWS resources
terraform apply

# Destroy when done (save costs!)
terraform destroy
```

## Testing

```bash
# Run tests locally
npm test

# Tests include:
# GET / - API response validation
# GET /db - Database connectivity check
```

## Learning Documentation

Each step of this DevOps journey is documented in the `docs/` folder:

| Guide | Topic |
|-------|-------|
| [01 - Node.js & npm](docs/01-nodejs-npm.md) | Application basics |
| [02 - Testing](docs/02-testing.md) | Jest & Supertest |
| [03 - Docker](docs/03-docker.md) | Containerization |
| [04 - CI/CD](docs/04-ci-cd.md) | GitHub Actions |
| [05 - Docker Hub](docs/05-docker-hub.md) | Image registry |
| [06 - Cloud Deployment](docs/06-cloud-deployment.md) | Render |
| [07 - Docker Compose](docs/07-docker-compose.md) | Multi-container |
| [08 - Kubernetes](docs/08-kubernetes.md) | Container orchestration |
| [09 - Jenkinsfile](docs/09-jenkinsfile.md) | Pipeline as code |
| [10 - AWS Deployment](docs/10-aws-deployment.md) | ECS Fargate |
| [11 - Terraform](docs/11-terraform.md) | Infrastructure as Code |

## Quick Start

```bash
# Clone the repo
git clone https://github.com/AnassEhab33/devops-starter.git
cd devops-starter

# Install dependencies
npm install

# Run locally
npm start

# Run with hot reload
npm run dev

# Run tests
npm test

# Run with Docker Compose (includes PostgreSQL)
docker-compose up --build
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Returns app info with timestamp |
| GET | `/db` | Database health check |

## Author

**Anass Einshouka** - DevOps Learning Journey

---

*This project demonstrates a complete DevOps pipeline from local development to cloud deployment, built as a hands-on learning experience.*
