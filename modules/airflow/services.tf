############################################################
# API Server
############################################################

resource "aws_ecs_service" "api" {

  name            = "${local.name_prefix}-airflow-api"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.api.arn

  desired_count = var.api_desired_count

  launch_type = "EC2"

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  health_check_grace_period_seconds = 120

  network_configuration {
    subnets = var.private_subnet_ids

    security_groups = [
      var.ecs_security_group_id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.airflow_target_group_arn
    container_name   = "airflow-api"
    container_port   = 8080
  }

  service_registries {
    registry_arn = aws_service_discovery_service.api.arn
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-airflow-api-service"
    }
  )
}


############################################################
# Scheduler
############################################################

resource "aws_ecs_service" "scheduler" {

  name            = "${local.name_prefix}-airflow-scheduler"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.scheduler.arn

  desired_count = var.scheduler_desired_count

  launch_type = "EC2"

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets = var.private_subnet_ids

    security_groups = [
      var.ecs_security_group_id
    ]

    assign_public_ip = false
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-airflow-scheduler-service"
    }
  )
}


############################################################
# DAG Processor
############################################################

resource "aws_ecs_service" "dag_processor" {

  name            = "${local.name_prefix}-airflow-dag-processor"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.dag_processor.arn

  desired_count = var.dag_processor_desired_count

  launch_type = "EC2"

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets = var.private_subnet_ids

    security_groups = [
      var.ecs_security_group_id
    ]

    assign_public_ip = false
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-airflow-dag-processor-service"
    }
  )
}


############################################################
# Celery Worker
############################################################

resource "aws_ecs_service" "worker" {

  name            = "${local.name_prefix}-airflow-worker"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.worker.arn

  desired_count = var.worker_desired_count

  launch_type = "EC2"

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets = var.private_subnet_ids

    security_groups = [
      var.ecs_security_group_id
    ]

    assign_public_ip = false
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-airflow-worker-service"
    }
  )
}


############################################################
# Triggerer
############################################################

resource "aws_ecs_service" "triggerer" {

  name            = "${local.name_prefix}-airflow-triggerer"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.triggerer.arn

  desired_count = var.triggerer_desired_count

  launch_type = "EC2"

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets = var.private_subnet_ids

    security_groups = [
      var.ecs_security_group_id
    ]

    assign_public_ip = false
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-airflow-triggerer-service"
    }
  )
}
