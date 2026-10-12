output "mysql_endpoint" {

  description = "MySQL RDS endpoint"

  value = aws_db_instance.mysql.address
}

output "mysql_port" {

  description = "MySQL RDS port"

  value = aws_db_instance.mysql.port
}

output "mysql_security_group_id" {

  description = "MySQL RDS security group ID"

  value = aws_security_group.mysql.id
}
