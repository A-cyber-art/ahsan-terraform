aws_region = "us-east-1"

security_group_name = "employee-ecs-sg"
container_port      = 5000
allowed_cidr_blocks = ["0.0.0.0/0"]

ecr_repository_name = "employee-app"
cluster_name        = "employee-cluster"

execution_role_name  = "employee-ecs-execution-role"
execution_policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

task_family    = "employee-app"
container_name = "employee-container"

cpu    = "256"
memory = "512"

service_name  = "employee-service"
desired_count = 1
