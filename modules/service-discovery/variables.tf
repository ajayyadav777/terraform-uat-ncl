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

variable "elasticsearch_private_ip" {
  type        = string
  description = "Private IP address of the Elasticsearch EC2 instance"
}
