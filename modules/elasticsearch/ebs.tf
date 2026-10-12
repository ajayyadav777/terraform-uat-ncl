data "aws_subnet" "selected" {
  id = var.private_subnet_id
}

resource "aws_ebs_volume" "data" {
  availability_zone = data.aws_subnet.selected.availability_zone

  size      = var.elasticsearch_data_volume_size
  type      = "gp3"
  encrypted = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-elasticsearch-data"
    }
  )

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_volume_attachment" "data" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.data.id
  instance_id = aws_instance.this.id

  force_detach = true
}
