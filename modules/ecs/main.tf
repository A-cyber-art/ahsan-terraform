resource "aws_ecr_repository" "employee_app" {
  name = var.ecr_repository_name
}

resource "aws_ecs_cluster" "employee_cluster" {
  name = var.cluster_name
}

resource "aws_iam_role" "ecs_execution_role" {
  name = var.execution_role_name

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
  policy_arn = var.execution_policy_arn
}

resource "aws_ecs_task_definition" "employee_task" {
  family                   = var.task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = "${aws_ecr_repository.employee_app.repository_url}:latest"

      essential = true

      portMappings = [{
        containerPort = var.container_port
        hostPort      = var.container_port
        protocol      = "tcp"
      }]
    }
  ])
}

resource "aws_ecs_service" "employee_service" {
  name                   = var.service_name
  cluster                = aws_ecs_cluster.employee_cluster.id
  task_definition        = "${aws_ecs_task_definition.employee_task.family}:${aws_ecs_task_definition.employee_task.revision}"
  desired_count          = var.desired_count
  launch_type            = "FARGATE"
  wait_for_steady_state  = false

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }
}
