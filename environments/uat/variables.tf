variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "ncl"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "uat"
}

variable "owner" {
  description = "Infrastructure owner"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)

  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)

  default = [
    "10.20.1.0/24",
    "10.20.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)

  default = [
    "10.20.11.0/24",
    "10.20.12.0/24"
  ]
}

variable "ecs_ami_id" {
  description = "ECS optimized AMI"
  type        = string
}

variable "ecs_instance_type" {
  description = "ECS EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "ecs_min_size" {
  description = "Minimum ECS instances"
  type        = number
  default     = 2
}

variable "ecs_desired_size" {
  description = "Desired ECS instances"
  type        = number
  default     = 2
}

variable "ecs_max_size" {
  description = "Maximum ECS instances"
  type        = number
  default     = 4
}

variable "ecs_root_volume_size" {
  description = "ECS root volume"
  type        = number
  default     = 30
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "bastion_ami_id" {
  description = "AMI ID for Bastion"
  type        = string
}

variable "jenkins_ami_id" {
  description = "AMI ID for Jenkins"
  type        = string
}

variable "bastion_instance_type" {
  description = "Bastion instance type"
  type        = string
  default     = "t3.micro"
}

variable "jenkins_instance_type" {
  description = "Jenkins instance type"
  type        = string
  default     = "t3.medium"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH to Bastion"
  type        = string
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

variable "elasticsearch_ami_id" {
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

variable "airflow_admin_username" {
  type        = string
  description = "Airflow web UI admin username"
  sensitive   = true
}

variable "airflow_admin_password" {
  type        = string
  description = "Airflow web UI admin password"
  sensitive   = true
}

variable "airflow_fernet_key" {
  type        = string
  description = "Airflow Fernet encryption key"
  sensitive   = true
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
