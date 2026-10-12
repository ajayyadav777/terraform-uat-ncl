variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ecs_security_group_id" {
  type = string
}

variable "postgres_username" {
  type      = string
  sensitive = true
}

variable "postgres_password" {
  type      = string
  sensitive = true
}

variable "postgres_engine_version" {
  type    = string
  default = "13"
}

variable "postgres_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "postgres_allocated_storage" {
  type    = number
  default = 30
}
