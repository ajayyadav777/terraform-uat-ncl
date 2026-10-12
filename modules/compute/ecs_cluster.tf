############################################################
# ECS Cluster
############################################################

resource "aws_ecs_cluster" "this" {

  name = "${local.name_prefix}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ecs-cluster"
    }
  )
}
