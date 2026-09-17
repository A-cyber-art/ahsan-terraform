variable "aws_region" {
  type = string
}

variable "security_group_name" {
  type = string
}

variable "container_port" {
  type = number
}

variable "allowed_cidr_blocks" {
  type = list(string)
}

variable "ecr_repository_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "execution_role_name" {
  type = string
}

variable "execution_policy_arn" {
  type = string
}

variable "task_family" {
  type = string
}

variable "container_name" {
  type = string
}

variable "cpu" {
  type = string
}

variable "memory" {
  type = string
}

variable "service_name" {
  type = string
}

variable "desired_count" {
  type = number
}
