resource "aws_ecs_task_definition" "backend" {
  family             = "${local.name_prefix}-backend"
  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]

  cpu    = var.backend_cpu
  memory = var.backend_memory

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = var.backend_image
      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "NODE_ENV"
          value = "uat"
        },
        {
          name  = "PORT"
          value = "3000"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.backend.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "backend"
        }
      }
    }
  ])

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-backend-task"
    }
  )
}
