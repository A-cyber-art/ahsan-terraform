output "security_group_id" {
  value = aws_security_group.ecs_sg.id
}

output "subnet_ids" {
  value = data.aws_subnets.default.ids
}
