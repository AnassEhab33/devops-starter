# ============================================
# MAIN TERRAFORM CONFIG
# This file recreates EVERYTHING you did 
# manually in AWS Console, but as CODE!
# ============================================


# ---- 1. ECS CLUSTER ----
# Same as: AWS Console → ECS → Create Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"
}


# ---- 2. IAM ROLE ----
# Same as: AWS Console → IAM → Create Role → ECS Task
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

# Attach the policy to the role (gives permission to pull from ECR)
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ---- 3. GET DEFAULT VPC AND SUBNETS ----
# Use the VPC and subnets that already exist in your AWS account
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


# ---- 4. SECURITY GROUP ----
# Same as: AWS Console → EC2 → Security Groups → Create
# This is like a firewall - allows traffic on port 3000
resource "aws_security_group" "app" {
  name        = "${var.app_name}-sg"
  description = "Allow traffic on port ${var.container_port}"
  vpc_id      = data.aws_vpc.default.id

  # Allow incoming traffic on port 3000 from anywhere
  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# ---- 5. TASK DEFINITION ----
# Same as: aws/task-definition.json + register-task-definition
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


# ---- 6. ECS SERVICE ----
# Same as: AWS Console → ECS → Create Service
# This keeps your container running!
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
