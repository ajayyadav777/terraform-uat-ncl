############################################################
# MySQL RDS
############################################################

resource "aws_db_instance" "mysql" {

  identifier = "${local.name_prefix}-mysql"

  engine = "mysql"

  engine_version = var.mysql_engine_version

  instance_class = var.mysql_instance_class

  allocated_storage = var.mysql_allocated_storage

  storage_type = "gp3"

  storage_encrypted = true

  username = var.mysql_username

  password = var.mysql_password

  port = var.mysql_port

  db_subnet_group_name = aws_db_subnet_group.mysql.name

  vpc_security_group_ids = [
    aws_security_group.mysql.id
  ]

  publicly_accessible = false

  multi_az = false

  backup_retention_period = 7

  backup_window = "03:00-04:00"

  maintenance_window = "sun:04:00-sun:05:00"

  auto_minor_version_upgrade = true

  deletion_protection = false

  skip_final_snapshot = true

  copy_tags_to_snapshot = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-mysql"
    }
  )
}
