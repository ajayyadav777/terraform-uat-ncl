############################################################
# ECS Auto Scaling Group
############################################################

resource "aws_autoscaling_group" "ecs" {

  name = "${local.name_prefix}-ecs-asg"

  min_size = var.ecs_min_size

  desired_capacity = var.ecs_desired_size

  max_size = var.ecs_max_size

  vpc_zone_identifier = var.private_subnet_ids

  health_check_type = "EC2"

  health_check_grace_period = 300

  protect_from_scale_in = false

  launch_template {

    id = aws_launch_template.ecs.id

    version = "$Latest"
  }

  tag {

    key = "Name"

    value = "${local.name_prefix}-ecs"

    propagate_at_launch = true
  }

  tag {

    key = "AmazonECSManaged"

    value = "true"

    propagate_at_launch = true
  }

  lifecycle {

    create_before_destroy = true
  }
}
