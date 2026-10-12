variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "ecs_cluster_id" {
  type = string
}

variable "ecs_security_group_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "airflow_image" {
  type = string
}

variable "airflow_target_group_arn" {
  type = string
}

variable "airflow_base_url" {
  type = string
}

variable "postgres_endpoint" {
  type = string
}

variable "postgres_port" {
  type = number
}

variable "postgres_database" {
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

variable "redis_url" {
  type      = string
  sensitive = true
}

variable "s3_bucket_arn" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "airflow_admin_username" {
  type      = string
  sensitive = true
}

variable "airflow_admin_password" {
  type      = string
  sensitive = true
}

variable "airflow_fernet_key" {
  type      = string
  sensitive = true
}

variable "api_cpu" {
  type    = number
  default = 1024
}

variable "api_memory" {
  type    = number
  default = 2048
}

variable "scheduler_cpu" {
  type    = number
  default = 1024
}

variable "scheduler_memory" {
  type    = number
  default = 2048
}

variable "dag_processor_cpu" {
  type    = number
  default = 512
}

variable "dag_processor_memory" {
  type    = number
  default = 1024
}

variable "worker_cpu" {
  type    = number
  default = 1024
}

variable "worker_memory" {
  type    = number
  default = 2048
}

variable "triggerer_cpu" {
  type    = number
  default = 512
}

variable "triggerer_memory" {
  type    = number
  default = 1024
}

variable "api_desired_count" {
  type    = number
  default = 2
}

variable "scheduler_desired_count" {
  type    = number
  default = 1
}

variable "dag_processor_desired_count" {
  type    = number
  default = 1
}

variable "worker_desired_count" {
  type    = number
  default = 1
}

variable "triggerer_desired_count" {
  type    = number
  default = 1
}

variable "airflow_namespace_id" {
  type = string
}

variable "airflow_secret_key" {
  type        = string
  sensitive   = true
  description = "Secret key used by the Airflow API server"
}

variable "airflow_jwt_secret" {
  type        = string
  sensitive   = true
  description = "JWT signing secret used by Airflow API authentication"
}
