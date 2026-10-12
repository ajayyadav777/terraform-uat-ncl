locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

resource "aws_security_group" "elasticsearch" {
  name        = "${local.name_prefix}-elasticsearch-sg"
  description = "Security group for private Elasticsearch"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Elasticsearch from ECS"
    from_port       = 9200
    to_port         = 9200
    protocol        = "tcp"
    security_groups = [var.ecs_security_group_id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-elasticsearch-sg"
    }
  )
}
