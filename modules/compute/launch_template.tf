############################################################
# ECS Launch Template
############################################################

resource "aws_launch_template" "ecs" {

  name = "${local.name_prefix}-ecs-lt"

  image_id = var.ecs_ami_id

  instance_type = var.ecs_instance_type

  key_name = var.key_name

  vpc_security_group_ids = [
    aws_security_group.ecs.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs.name
  }

  user_data = base64encode(<<-EOF
#!/bin/bash

set -euxo pipefail

############################################################
# ECS Configuration
############################################################

mkdir -p /etc/ecs

cat > /etc/ecs/ecs.config <<EOCONFIG
ECS_CLUSTER=${aws_ecs_cluster.this.name}
ECS_ENABLE_TASK_IAM_ROLE=true
ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true
ECS_LOGLEVEL=info
EOCONFIG

############################################################
# Enable ECS Agent
############################################################

systemctl daemon-reload

systemctl enable ecs.service

systemctl restart ecs.service

############################################################
# Verify ECS Configuration
############################################################

echo "ECS configuration:"
cat /etc/ecs/ecs.config

echo "ECS service status:"
systemctl status ecs.service --no-pager || true

EOF
  )

  block_device_mappings {

    device_name = "/dev/xvda"

    ebs {

      volume_size = var.ecs_root_volume_size

      volume_type = "gp3"

      encrypted = true

      delete_on_termination = true
    }
  }

  tag_specifications {

    resource_type = "instance"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.name_prefix}-ecs"
      }
    )
  }

  tag_specifications {

    resource_type = "volume"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.name_prefix}-ecs-volume"
      }
    )
  }

  tags = local.common_tags
}
