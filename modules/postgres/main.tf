locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

resource "aws_db_subnet_group" "this" {
  name = "${local.name_prefix}-postgres-subnet-group"

  subnet_ids = var.private_subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-postgres-subnet-group"
    }
  )
}

resource "aws_security_group" "this" {
  name        = "${local.name_prefix}-postgres-sg"
  description = "Security group for Airflow PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from ECS"
    from_port       = 5432
    to_port         = 5432
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
      Name = "${local.name_prefix}-postgres-sg"
    }
  )
}

resource "aws_db_instance" "this" {
  identifier = "${local.name_prefix}-airflow-postgres"

  engine         = "postgres"
  engine_version = var.postgres_engine_version

  instance_class      = var.postgres_instance_class
  allocated_storage   = var.postgres_allocated_storage
  storage_type        = "gp3"
  storage_encrypted   = true
  publicly_accessible = false

  db_name  = "airflow"
  username = var.postgres_username
  password = var.postgres_password
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  multi_az                = false
  backup_retention_period = 7

  deletion_protection = false
  skip_final_snapshot = true

  auto_minor_version_upgrade = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-airflow-postgres"
    }
  )
}
