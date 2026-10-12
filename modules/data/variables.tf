variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "owner" {
  description = "Resource owner"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for RDS"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "ECS security group allowed to connect to MySQL"
  type        = string
}

variable "mysql_engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}

variable "mysql_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "mysql_allocated_storage" {
  description = "Initial RDS storage in GB"
  type        = number
  default     = 30
}

variable "mysql_username" {
  description = "MySQL master username"
  type        = string
  sensitive   = true
}

variable "mysql_password" {
  description = "MySQL master password"
  type        = string
  sensitive   = true
}

variable "mysql_port" {
  description = "MySQL port"
  type        = number
  default     = 3306
}
