############################################################
# ECS Capacity Provider
############################################################

resource "aws_ecs_capacity_provider" "this" {

  name = "${local.name_prefix}-capacity-provider"

  auto_scaling_group_provider {

    auto_scaling_group_arn = aws_autoscaling_group.ecs.arn

    managed_scaling {

      status = "ENABLED"

      target_capacity = 80

      minimum_scaling_step_size = 1

      maximum_scaling_step_size = 2

    }

    managed_termination_protection = "DISABLED"
  }

  tags = local.common_tags
}


############################################################
# Attach Capacity Provider to ECS Cluster
############################################################

resource "aws_ecs_cluster_capacity_providers" "this" {

  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = [
    aws_ecs_capacity_provider.this.name
  ]

  default_capacity_provider_strategy {

    capacity_provider = aws_ecs_capacity_provider.this.name

    weight = 1

    base = 1
  }
}
