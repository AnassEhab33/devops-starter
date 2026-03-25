# AWS ECS Deployment - Complete Beginner Guide

## What is AWS? (The Basics)

AWS (Amazon Web Services) = Amazon's cloud platform. Think of it as a HUGE computer center that you can rent.

### Key Concepts You Need to Know:

| AWS Term | What It Is | Analogy |
|----------|-----------|---------|
| **Region** | Physical location of servers | "Which city is my server in?" (use us-east-1) |
| **ECR** | Elastic Container Registry | Like Docker Hub, but on AWS |
| **ECS** | Elastic Container Service | Runs your Docker containers on AWS |
| **Fargate** | Serverless container runner | "Run my container, I don't want to manage servers" |
| **Task Definition** | Blueprint for your container | Like `docker-compose.yml` but for AWS |
| **Service** | Keeps your containers running | "Always keep 1 copy of my app running" |
| **Cluster** | Group of containers | Like a Kubernetes cluster |
| **IAM** | Identity & Access Management | Users and permissions |
| **Security Group** | Firewall rules | "Allow traffic on port 3000" |

### How ECS Compares to What You Know:

```
Docker Compose (local):           AWS ECS (cloud):
  docker-compose.yml        →       Task Definition
  services:                 →       Services
  ports: "3000:3000"       →       Security Group + Port mapping
  image: anassehab33/...   →       Image from ECR or Docker Hub
```

## Step-by-Step Setup

### Step 1: Install AWS CLI

In PowerShell:
```bash
winget install Amazon.AWSCLI
```
Close and reopen PowerShell. Verify:
```bash
aws --version
```

### Step 2: Create Access Keys

1. Go to [AWS Console](https://console.aws.amazon.com)
2. Top right → Click your name → **Security Credentials**
3. Scroll down to **Access Keys** → **Create Access Key**
4. Choose **"Command Line Interface (CLI)"**
5. Check the acknowledgement box → **Create**
6. **COPY both keys** (you won't see them again!)

### Step 3: Configure AWS CLI

```bash
aws configure
```
Enter:
- Access Key ID: (paste your key)
- Secret Access Key: (paste your secret)
- Region: `us-east-1`
- Output format: `json`

### Step 4: Create ECR Repository (Your Docker Hub on AWS)

```bash
# Create a repository to store your Docker images
aws ecr create-repository --repository-name devops-starter --region us-east-1
```

This creates a place on AWS to store your Docker images (like Docker Hub).

### Step 5: Push Docker Image to ECR

```bash
# 1. Login to ECR (get password and login to Docker)
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

# 2. Build your image
docker build -t devops-starter .

# 3. Tag it for ECR
docker tag devops-starter:latest YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/devops-starter:latest

# 4. Push to ECR
docker push YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/devops-starter:latest
```

(Replace YOUR_ACCOUNT_ID with your actual AWS account ID - find it in the top right of AWS Console)

### Step 6: Create ECS Cluster

```bash
# Create a cluster (group for your containers)
aws ecs create-cluster --cluster-name devops-cluster
```

### Step 7: Create IAM Execution Role (Required for Fargate)

Fargate needs permission to pull your Docker image from ECR. You create a "role" (like a key) that gives it access.

1. Go to [AWS Console](https://console.aws.amazon.com) → Search **"IAM"** → Click **IAM**
2. Left sidebar → **Roles** → Click **"Create role"**
3. **Trusted entity type:** Select **"AWS service"**
4. **Use case:** Select **"Elastic Container Service"** → Then select **"Elastic Container Service Task"**
5. Click **Next**
6. Search for **`AmazonECSTaskExecutionRolePolicy`** → ✅ Check it
7. Click **Next**
8. **Role name:** Type `ecsTaskExecutionRole`
9. Click **"Create role"** ✅

```
Without this role:
  ECS: "I need to pull image from ECR" → "Do I have permission?" → ❌ NO

With this role:
  ECS: "I need to pull image from ECR" → "I have ecsTaskExecutionRole" → ✅ YES
```

### Step 8: Create Task Definition

Create a file `aws/task-definition.json`:
```json
{
  "family": "devops-starter",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "executionRoleArn": "arn:aws:iam::YOUR_ACCOUNT_ID:role/ecsTaskExecutionRole",
  "containerDefinitions": [
    {
      "name": "devops-starter",
      "image": "YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/devops-starter:latest",
      "portMappings": [
        {
          "containerPort": 3000,
          "protocol": "tcp"
        }
      ],
      "essential": true
    }
  ]
}
```

Register it:
```bash
aws ecs register-task-definition --cli-input-json file://aws/task-definition.json
```

### Step 9: Create and Run Service (AWS Console)

1. Go to **ECS** → **Clusters** → **devops-cluster**
2. Click **"Services"** tab → Click **"Create"**
3. **Compute options:** Select **FARGATE**
4. **Task definition:** Select `devops-starter` → Revision: `LATEST`
5. **Service name:** `devops-starter-service`
6. **Desired tasks:** `1`
7. **Networking:**
   - VPC: default
   - Create new security group: allow **TCP port 3000** from **Anywhere**
   - Public IP: **ON** ✅
8. Click **"Create"**

### Step 10: Access Your App

1. Go to **ECS** → **Clusters** → **devops-cluster** → **Tasks** tab
2. Click the running task
3. Find the **Public IP**
4. Visit: `http://PUBLIC_IP:3000` 🎉

## Cost Estimate

| Resource | Monthly Cost |
|----------|-------------|
| ECR (image storage) | ~$0.10 |
| ECS Fargate (256 CPU, 512 MB) | ~$5-10 |
| **Total** | **~$5-10/month** |

With $100 credit, you can run this for **10+ months**! ✅

## The Full Flow After Setup

```
git push → GitHub Actions → Build Image → Push to ECR → Deploy to ECS → Live! 🌐
```
