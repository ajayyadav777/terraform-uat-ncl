resource "aws_ecs_task_definition" "frontend" {
  family             = "${local.name_prefix}-frontend"
  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]

  cpu    = var.frontend_cpu
  memory = var.frontend_memory

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = var.frontend_image
      essential = true

      portMappings = [
        {
          containerPort = 4200
          hostPort      = 4200
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
          value = "4200"
        }
      ]

      healthCheck = {
        command = [
          "CMD-SHELL",
          "curl -f http://localhost:4200/ || exit 1"
        ]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.frontend.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "frontend"
        }
      }
    }
  ])

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-frontend-task"
    }
  )
}
