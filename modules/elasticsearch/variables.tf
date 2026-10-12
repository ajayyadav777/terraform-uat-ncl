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

variable "private_subnet_id" {
  type = string
}

variable "ecs_security_group_id" {
  type = string
}

variable "elasticsearch_ami_id" {
  type = string
}

variable "elasticsearch_instance_type" {
  type    = string
  default = "t3.large"
}

variable "elasticsearch_data_volume_size" {
  type    = number
  default = 30
}

variable "key_name" {
  type = string
}
