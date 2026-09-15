resource "aws_ecs_cluster" "employee_cluster" {
  name = "employee-cluster"
}

resource "aws_ecs_task_definition" "employee_task" {
  family                   = "employee-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "employee-container"
      image     = "${aws_ecr_repository.employee_app.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]
    }
  ])
}
