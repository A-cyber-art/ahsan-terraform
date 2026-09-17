terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "../../modules/networking"

  security_group_name = var.security_group_name
  container_port      = var.container_port
  allowed_cidr_blocks = var.allowed_cidr_blocks
}

module "ecs" {
  source = "../../modules/ecs"

  ecr_repository_name  = var.ecr_repository_name
  cluster_name         = var.cluster_name
  execution_role_name  = var.execution_role_name
  execution_policy_arn = var.execution_policy_arn
  task_family          = var.task_family
  container_name       = var.container_name
  container_port       = var.container_port
  cpu                  = var.cpu
  memory               = var.memory
  service_name         = var.service_name
  desired_count        = var.desired_count

  subnet_ids        = module.networking.subnet_ids
  security_group_id = module.networking.security_group_id
}
