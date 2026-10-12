############################################################
# Bastion Host
############################################################

resource "aws_instance" "bastion" {

  ami = var.bastion_ami_id

  instance_type = var.bastion_instance_type

  subnet_id = var.public_subnet_id

  associate_public_ip_address = true

  key_name = var.key_name

  vpc_security_group_ids = [
    aws_security_group.bastion.id
  ]

  root_block_device {

    volume_size = 20

    volume_type = "gp3"

    encrypted = true

    delete_on_termination = true
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-bastion"
    }
  )
}
