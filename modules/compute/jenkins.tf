############################################################
# Jenkins Server
############################################################

resource "aws_instance" "jenkins" {

  ami = var.jenkins_ami_id

  instance_type = var.jenkins_instance_type

  subnet_id = var.private_subnet_ids[0]

  associate_public_ip_address = false

  key_name = var.key_name

  vpc_security_group_ids = [
    aws_security_group.jenkins.id
  ]

  root_block_device {

    volume_size = 50

    volume_type = "gp3"

    encrypted = true

    delete_on_termination = true
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-jenkins"
    }
  )
}
