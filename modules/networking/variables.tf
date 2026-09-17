variable "security_group_name" {
  type = string
}

variable "container_port" {
  type = number
}

variable "allowed_cidr_blocks" {
  type = list(string)
}
