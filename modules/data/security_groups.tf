############################################################
# MySQL RDS Security Group
############################################################

resource "aws_security_group" "mysql" {

  name = "${local.name_prefix}-mysql-sg"

  description = "Security group for NCL UAT MySQL RDS"

  vpc_id = var.vpc_id

  ingress {

    description = "MySQL from ECS"

    from_port = var.mysql_port

    to_port = var.mysql_port

    protocol = "tcp"

    security_groups = [
      var.ecs_security_group_id
    ]
  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-mysql-sg"
    }
  )
}
