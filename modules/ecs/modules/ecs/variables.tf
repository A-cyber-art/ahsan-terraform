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

variable "container_port" {
  type = number
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

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}
