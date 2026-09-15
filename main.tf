provider "aws" {
  region = "us-east-1"
}

# ECR
resource "aws_ecr_repository" "employee_app" {
  name = "employee-app"
}

# ECS Cluster
resource "aws_ecs_cluster" "employee_cluster" {
  name = "employee-cluster"
}

# IAM role for Fargate
resource "aws_iam_role" "ecs_execution_role" {
  name = "employee-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Default VPC
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group
resource "aws_security_group" "ecs_sg" {
  name   = "employee-ecs-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 5000
    to_port     = 5000
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

# Fargate Task
resource "aws_ecs_task_definition" "employee_task" {
  family                   = "employee-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "employee-container"
      image = "${aws_ecr_repository.employee_app.repository_url}:latest"

      essential = true

      portMappings = [{
        containerPort = 5000
        hostPort      = 5000
        protocol      = "tcp"
      }]
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "employee_service" {
  name            = "employee-service"
  cluster         = aws_ecs_cluster.employee_cluster.id
  task_definition = aws_ecs_task_definition.employee_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}
