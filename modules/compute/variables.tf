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

variable "public_subnet_id" {
  description = "Public subnet for bastion"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets"
  type        = list(string)
}

variable "bastion_ami_id" {
  description = "AMI ID for bastion"
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

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH to bastion"
  type        = string
}

variable "ecs_instance_type" {
  description = "ECS EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "ecs_ami_id" {
  description = "ECS optimized AMI ID"
  type        = string
}

variable "ecs_min_size" {
  description = "Minimum ECS EC2 instances"
  type        = number
  default     = 2
}

variable "ecs_desired_size" {
  description = "Desired ECS EC2 instances"
  type        = number
  default     = 2
}

variable "ecs_max_size" {
  description = "Maximum ECS EC2 instances"
  type        = number
  default     = 4
}

variable "ecs_root_volume_size" {
  description = "ECS EC2 root volume size"
  type        = number
  default     = 30
}

