output "ecr_repository_url" {
  value = aws_ecr_repository.employee_app.repository_url
}

output "cluster_id" {
  value = aws_ecs_cluster.employee_cluster.id
}

output "cluster_name" {
  value = aws_ecs_cluster.employee_cluster.name
}

output "execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.employee_task.arn
}

output "service_name" {
  value = aws_ecs_service.employee_service.name
}
