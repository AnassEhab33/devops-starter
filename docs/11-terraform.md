# Terraform - Infrastructure as Code (Complete Guide)

## What is Terraform?

**Terraform** = Write code to create cloud resources instead of clicking in AWS Console.

```
Without Terraform (what you did):
  1. Login to AWS Console
  2. Click "Create Cluster"
  3. Click "Create Role"
  4. Click "Create Service"
  → Can't repeat easily, no version control

With Terraform:
  1. Write a .tf file
  2. Run: terraform apply
  → Everything created automatically! Stored in Git!
```

## Core Concepts

| Concept | Meaning | Analogy |
|---------|---------|---------|
| **Provider** | Which cloud (AWS, Azure, GCP) | "I'm working with AWS" |
| **Resource** | Something to create (cluster, role) | "Create an ECS cluster" |
| **Data** | Look up something that already exists | "Find the default VPC" |
| **State** | Terraform remembers what it created | "I already made the cluster" |
| **Plan** | Preview changes before applying | "Here's what I WILL do" |
| **Apply** | Actually create the resources | "Do it!" |
| **Destroy** | Delete everything | "Remove everything I created" |
| **Variable** | Reusable values | Like environment variables |
| **Output** | Show results after apply | Like console.log() |

## Key Commands

| Command | What It Does | Compare to npm |
|---------|-------------|---------------|
| `terraform init` | Download providers | `npm install` |
| `terraform plan` | Preview changes | `npm test` |
| `terraform apply` | Create resources | `npm start` |
| `terraform destroy` | Delete ALL resources | - |
| `terraform fmt` | Format code nicely | - |

## File Structure

```
terraform/
├── provider.tf      ← "Which cloud am I using?"
├── variables.tf     ← Reusable values
├── main.tf          ← ALL AWS resources
└── outputs.tf       ← Show results after creation
```

---

## 📄 File 1: provider.tf (The Simplest File)

```hcl
provider "aws" {
  region = var.aws_region
}
```

| Line | Meaning |
|------|---------|
| `provider "aws"` | "I want to use AWS cloud" |
| `region = var.aws_region` | "Deploy in this region" (reads from variables.tf) |

Analogy:
```
provider = "Which restaurant are we ordering from?"
  "aws" = "We're ordering from AWS!"
  region = "Which branch? The one in us-east-1"
```

Terraform supports many providers:
```
provider "aws"      → Amazon
provider "azurerm"  → Microsoft Azure
provider "google"   → Google Cloud
```

---

## 📄 File 2: variables.tf (Reusable Values)

```hcl
variable "aws_region" {
  description = "AWS region to deploy to"
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name of the application"
  default     = "devops-starter"
}

variable "container_port" {
  description = "Port the container listens on"
  default     = 3000
}

variable "aws_account_id" {
  description = "Your AWS Account ID"
  default     = "363191779124"
}
```

### Why Variables?

So you don't hardcode values everywhere:

```hcl
# WITHOUT variables (bad - hardcoded everywhere):
resource "aws_ecs_cluster" "main" {
  name = "devops-starter-cluster"     # Repeated!
}

# WITH variables (good - defined once):
variable "app_name" { default = "devops-starter" }
resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"    # Uses variable!
}
```

### Compare to JavaScript:

```javascript
// JavaScript:
const appName = "devops-starter";

// Terraform:
variable "app_name" { default = "devops-starter" }
```

### Your Variables:

| Variable | Value | Used For |
|----------|-------|----------|
| `aws_region` | `us-east-1` | Which AWS region |
| `app_name` | `devops-starter` | Naming everything |
| `container_port` | `3000` | Which port to open |
| `aws_account_id` | `363191779124` | Your AWS account |

---

## 📄 File 3: main.tf (ALL Resources - The Main File!)

This file recreates EVERYTHING you did manually in AWS Console.

---

### Section 1: ECS Cluster

```hcl
resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"
}
```

| Part | Meaning |
|------|---------|
| `resource` | "Create something" |
| `"aws_ecs_cluster"` | "An ECS cluster" (AWS resource type) |
| `"main"` | Your nickname for it in code |
| `name =` | The actual name on AWS |
| `${var.app_name}` | Inserts variable → `devops-starter-cluster` |

**Same as clicking:** AWS Console → ECS → Create Cluster

---

### Section 2: IAM Role

```hcl
resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole-tf"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
```

| Part | Meaning |
|------|---------|
| `aws_iam_role` | "Create an IAM role" |
| `name = "ecsTaskExecutionRole-tf"` | Name on AWS |
| `assume_role_policy` | "Who can use this role?" |
| `Service = "ecs-tasks.amazonaws.com"` | "ECS tasks can use this role" |
| `aws_iam_role_policy_attachment` | "Attach permission to the role" |
| `role = aws_iam_role.ecs_task_execution.name` | "Attach to the role we just created" |
| `policy_arn = ...` | "Give it ECR pull permission" |

**Notice:** `aws_iam_role.ecs_task_execution.name` references the role above! Terraform links resources together automatically.

**Same as clicking:** IAM → Create Role → ECS Task

---

### Section 3: Get Default VPC & Subnets

```hcl
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
```

| Part | Meaning |
|------|---------|
| `data` (not `resource`) | "Look up something that ALREADY exists" (don't create it) |
| `aws_vpc` | Your VPC (Virtual Private Cloud = your network on AWS) |
| `default = true` | "Find the default VPC" |
| `aws_subnets` | "Find subnets inside that VPC" |

Key difference:
```
resource = "CREATE something new"
data     = "FIND something that already exists"
```

---

### Section 4: Security Group

```hcl
resource "aws_security_group" "app" {
  name        = "${var.app_name}-sg"
  description = "Allow traffic on port ${var.container_port}"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

| Part | Meaning |
|------|---------|
| `aws_security_group` | "Create firewall rules" |
| `vpc_id = data.aws_vpc.default.id` | "Put it in the default VPC" (references Section 3!) |
| `ingress` | **Incoming** traffic rules |
| `from_port / to_port = 3000` | "Allow port 3000" |
| `cidr_blocks = ["0.0.0.0/0"]` | "From **anywhere** in the world" |
| `egress` | **Outgoing** traffic rules |
| `protocol = "-1"` | "Allow ALL protocols out" |

Analogy:
```
ingress = Front door: "Only let in people going to room 3000"
egress  = Back door: "Let everyone leave freely"
```

---

### Section 5: Task Definition

```hcl
resource "aws_ecs_task_definition" "app" {
  family                   = var.app_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = var.app_name
    image     = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.app_name}:latest"
    essential = true
    portMappings = [{
      containerPort = var.container_port
      protocol      = "tcp"
    }]
  }])
}
```

| Part | Meaning |
|------|---------|
| `family` | Group name for task versions |
| `cpu = "256"` | 0.25 vCPU (smallest, cheapest) |
| `memory = "512"` | 512 MB RAM |
| `execution_role_arn = aws_iam_role.ecs_task_execution.arn` | "Use the role from Section 2!" |
| `container_definitions` | Same as your `aws/task-definition.json` file! |
| `image = "...ecr.../devops-starter:latest"` | Docker image from ECR |

**Same as:** Your `aws/task-definition.json`, but now in Terraform code!

---

### Section 6: ECS Service

```hcl
resource "aws_ecs_service" "app" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.app.id]
    assign_public_ip = true
  }
}
```

| Part | Meaning |
|------|---------|
| `cluster = aws_ecs_cluster.main.id` | "Run in the cluster from Section 1" |
| `task_definition = aws_ecs_task_definition.app.arn` | "Use the task from Section 5" |
| `desired_count = 1` | "Keep 1 container running" |
| `subnets = data.aws_subnets.default.ids` | "Use subnets from Section 3" |
| `security_groups` | "Use firewall from Section 4" |
| `assign_public_ip = true` | "Give it a public IP so I can visit it!" |

---

## 📄 File 4: outputs.tf (Show Results)

```hcl
output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app.name
}
```

After `terraform apply`, it shows:
```
cluster_name = "devops-starter-cluster"
service_name = "devops-starter-service"
```

**Like `console.log()` in JavaScript!**

---

## 🔗 How Everything Connects

```
variables.tf  ──► provides values to all files
    │
provider.tf   ──► "Use AWS in us-east-1"
    │
main.tf:
    │
    ├── 1. Cluster
    │
    ├── 2. IAM Role ──────────────────┐
    │                                  │
    ├── 3. VPC/Subnets (lookup) ──┐   │
    │                              │   │
    ├── 4. Security Group ─────┐  │   │
    │                          │  │   │
    ├── 5. Task Definition ◄───│──│───┘ (uses role)
    │                          │  │
    └── 6. Service ◄───────────┘──┘ (uses SG + subnets + task + cluster)
    │
outputs.tf    ──► shows results
```

**Terraform figures out the order automatically!** It knows to create the role before the task definition, because the task definition references the role.

---

## Compare: Manual vs Terraform

| What | Manual (AWS Console) | Terraform |
|------|---------------------|-----------|
| Create cluster | Click buttons | `resource "aws_ecs_cluster"` |
| Create role | Click buttons | `resource "aws_iam_role"` |
| Create security group | Click buttons | `resource "aws_security_group"` |
| Create task definition | CLI + JSON file | `resource "aws_ecs_task_definition"` |
| Create service | Click buttons | `resource "aws_ecs_service"` |
| **Repeat it?** | Do it all again manually | `terraform apply` |
| **Version control?** | Screenshots? | Git! |
| **Delete everything?** | Click delete 5 times | `terraform destroy` |

---

## Running Terraform

```bash
# Step 1: Download providers (like npm install)
terraform init

# Step 2: Preview what will be created (like npm test)
terraform plan

# Step 3: Create everything! (like npm start)
terraform apply

# Step 4: When done, delete everything (saves money!)
terraform destroy
```
