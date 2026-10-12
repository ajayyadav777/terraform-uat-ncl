############################################################
# Airflow API Server
############################################################

resource "aws_ecs_task_definition" "api" {

  family = "${local.name_prefix}-airflow-api"

  execution_role_arn = aws_iam_role.execution.arn
  task_role_arn      = aws_iam_role.task.arn

  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]

  cpu    = var.api_cpu
  memory = var.api_memory

  container_definitions = jsonencode([
    {
      name      = "airflow-api"
      image     = var.airflow_image
      essential = true

      command = [
        "airflow",
        "api-server",
        "--host",
        "0.0.0.0",
        "--port",
        "8080",
        "--proxy-headers"
      ]

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]

      environment = local.airflow_environment

      healthCheck = {
        command = [
          "CMD-SHELL",
          "curl -f http://localhost:8080/api/v2/version || exit 1"
        ]
        interval    = 30
        timeout     = 10
        retries     = 5
        startPeriod = 120
      }

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.api.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "airflow-api"
        }
      }
    }
  ])

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-airflow-api-task"
    }
  )
}


############################################################
# Scheduler
############################################################

resource "aws_ecs_task_definition" "scheduler" {

  family = "${local.name_prefix}-airflow-scheduler"

  execution_role_arn = aws_iam_role.execution.arn
  task_role_arn      = aws_iam_role.task.arn

  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]

  cpu    = var.scheduler_cpu
  memory = var.scheduler_memory

  container_definitions = jsonencode([
    {
      name      = "airflow-scheduler"
      image     = var.airflow_image
      essential = true

      command = [
        "airflow",
        "scheduler"
      ]

      environment = local.airflow_environment

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.scheduler.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "scheduler"
        }
      }
    }
  ])

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-airflow-scheduler-task"
    }
  )
}


############################################################
# DAG Processor
############################################################

resource "aws_ecs_task_definition" "dag_processor" {

  family = "${local.name_prefix}-airflow-dag-processor"

  execution_role_arn = aws_iam_role.execution.arn
  task_role_arn      = aws_iam_role.task.arn

  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]

  cpu    = var.dag_processor_cpu
  memory = var.dag_processor_memory

  container_definitions = jsonencode([
    {
      name      = "airflow-dag-processor"
      image     = var.airflow_image
      essential = true

      command = [
        "airflow",
        "dag-processor"
      ]

      environment = local.airflow_environment

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.dag_processor.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "dag-processor"
        }
      }
    }
  ])

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-airflow-dag-processor-task"
    }
  )
}


############################################################
# Celery Worker
############################################################

resource "aws_ecs_task_definition" "worker" {

  family = "${local.name_prefix}-airflow-worker"

  execution_role_arn = aws_iam_role.execution.arn
  task_role_arn      = aws_iam_role.task.arn

  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]

  cpu    = var.worker_cpu
  memory = var.worker_memory

  container_definitions = jsonencode([
    {
      name      = "airflow-worker"
      image     = var.airflow_image
      essential = true

      command = [
        "airflow",
        "celery",
        "worker"
      ]

      environment = concat(
        local.airflow_environment,
        [
          {
            name  = "DUMB_INIT_SETSID"
            value = "0"
          }
        ]
      )

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.worker.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "worker"
        }
      }
    }
  ])

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-airflow-worker-task"
    }
  )
}


############################################################
# Triggerer
############################################################

resource "aws_ecs_task_definition" "triggerer" {

  family = "${local.name_prefix}-airflow-triggerer"

  execution_role_arn = aws_iam_role.execution.arn
  task_role_arn      = aws_iam_role.task.arn

  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]

  cpu    = var.triggerer_cpu
  memory = var.triggerer_memory

  container_definitions = jsonencode([
    {
      name      = "airflow-triggerer"
      image     = var.airflow_image
      essential = true

      command = [
        "airflow",
        "triggerer"
      ]

      environment = local.airflow_environment

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.triggerer.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "triggerer"
        }
      }
    }
  ])

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-airflow-triggerer-task"
    }
  )
}


############################################################
# Database Migration / Admin Initialization Task
############################################################

resource "aws_ecs_task_definition" "init" {

  family = "${local.name_prefix}-airflow-init"

  execution_role_arn = aws_iam_role.execution.arn
  task_role_arn      = aws_iam_role.task.arn

  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]

  cpu    = 512
  memory = 1024

  container_definitions = jsonencode([
    {
      name      = "airflow-init"
      image     = var.airflow_image
      essential = true

      command = [
        "bash",
        "-c",
        "set -e; airflow db migrate; if airflow users list --output json | grep -q '\"username\": \"'\"$AIRFLOW_ADMIN_USERNAME\"'\"'; then echo 'Airflow admin user already exists'; else airflow users create --username \"$AIRFLOW_ADMIN_USERNAME\" --firstname Airflow --lastname Admin --role Admin --email admin@ncl.local --password \"$AIRFLOW_ADMIN_PASSWORD\"; fi"
      ]
      environment = concat(
        local.airflow_environment,
        [
          {
            name  = "AIRFLOW_ADMIN_USERNAME"
            value = var.airflow_admin_username
          },
          {
            name  = "AIRFLOW_ADMIN_PASSWORD"
            value = var.airflow_admin_password
          }
        ]
      )

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.init.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "init"
        }
      }
    }
  ])

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-airflow-init-task"
    }
  )
}
