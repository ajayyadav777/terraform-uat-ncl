############################################################
# RDS Subnet Group
############################################################

resource "aws_db_subnet_group" "mysql" {

  name = "${local.name_prefix}-mysql-subnet-group"

  subnet_ids = var.private_subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-mysql-subnet-group"
    }
  )
}
