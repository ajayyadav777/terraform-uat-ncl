resource "aws_cloudwatch_log_group" "api" {
  name              = "/ecs/${local.name_prefix}/airflow-api"
  retention_in_days = 14

  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "scheduler" {
  name              = "/ecs/${local.name_prefix}/airflow-scheduler"
  retention_in_days = 14

  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "dag_processor" {
  name              = "/ecs/${local.name_prefix}/airflow-dag-processor"
  retention_in_days = 14

  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "worker" {
  name              = "/ecs/${local.name_prefix}/airflow-worker"
  retention_in_days = 14

  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "triggerer" {
  name              = "/ecs/${local.name_prefix}/airflow-triggerer"
  retention_in_days = 14

  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "init" {
  name              = "/ecs/${local.name_prefix}/airflow-init"
  retention_in_days = 14

  tags = local.common_tags
}
