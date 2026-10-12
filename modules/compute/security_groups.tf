############################################################
# ECS Security Group
############################################################

resource "aws_security_group" "ecs" {

  name        = "${local.name_prefix}-ecs-sg"
  description = "Security group for ECS EC2 instances"
  vpc_id      = var.vpc_id

  # Frontend traffic from ALB
  ingress {
    description     = "Frontend traffic from ALB"
    from_port       = 4200
    to_port         = 4200
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Backend traffic from ALB
  ingress {
    description     = "Backend traffic from ALB"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Airflow traffic from ALB
  ingress {
    description     = "Airflow traffic from ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Allow ECS instances to communicate with each other
  ingress {
    description = "ECS internal communication"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"

    self = true
  }

  egress {
    description = "Outbound internet access through NAT"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ecs-sg"
    }
  )
}


############################################################
# ALB Security Group
############################################################

resource "aws_security_group" "alb" {

  name        = "${local.name_prefix}-alb-sg"
  description = "Security group for public ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb-sg"
    }
  )
}


############################################################
# Bastion Security Group
############################################################

resource "aws_security_group" "bastion" {

  name        = "${local.name_prefix}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from administrator"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = [
      var.allowed_ssh_cidr
    ]
  }

  egress {
    description = "Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-bastion-sg"
    }
  )
}


############################################################
# Jenkins Security Group
############################################################

resource "aws_security_group" "jenkins" {

  name        = "${local.name_prefix}-jenkins-sg"
  description = "Security group for private Jenkins"
  vpc_id      = var.vpc_id

  # SSH only from Bastion
  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  # Jenkins UI
  # We'll keep this restricted to Bastion.
  ingress {
    description     = "Jenkins UI from Bastion"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    description = "Outbound through NAT"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-jenkins-sg"
    }
  )
}
