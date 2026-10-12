resource "aws_ecs_service" "frontend" {
  name            = "${local.name_prefix}-frontend"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.frontend.arn

  desired_count = var.frontend_desired_count

  launch_type = "EC2"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  health_check_grace_period_seconds = 60

  network_configuration {
    subnets = var.private_subnet_ids

    security_groups = [
      var.ecs_security_group_id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.frontend_target_group_arn
    container_name   = "frontend"
    container_port   = 4200
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-frontend-service"
    }
  )
}
