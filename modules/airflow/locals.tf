locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }

  database_url = "postgresql+psycopg2://${var.postgres_username}:${var.postgres_password}@${var.postgres_endpoint}:${var.postgres_port}/${var.postgres_database}"

  execution_api_url = "http://airflow-api.${local.name_prefix}.local:8080/execution/"

  airflow_environment = [
    {
      name  = "AIRFLOW__CORE__EXECUTOR"
      value = "CeleryExecutor"
    },
    {
      name  = "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN"
      value = local.database_url
    },
    {
      name  = "AIRFLOW__CELERY__BROKER_URL"
      value = var.redis_url
    },
    {
      name  = "AIRFLOW__CELERY__RESULT_BACKEND"
      value = "db+${local.database_url}"
    },
    {
      name  = "AIRFLOW__CELERY__WORKER_CONCURRENCY"
      value = "2"
    },
    {
      name  = "AIRFLOW__CORE__FERNET_KEY"
      value = var.airflow_fernet_key
    },
    {
      name  = "AIRFLOW__API__BASE_URL"
      value = var.airflow_base_url
    },
    {
      name  = "AIRFLOW__CORE__EXECUTION_API_SERVER_URL"
      value = local.execution_api_url
    },
    {
      name  = "AIRFLOW__CORE__LOAD_EXAMPLES"
      value = "False"
    },
    {
      name  = "AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION"
      value = "True"
    },
    {
      name  = "AIRFLOW__API__SECRET_KEY"
      value = var.airflow_secret_key
    },
    {
      name  = "AIRFLOW__API_AUTH__JWT_SECRET"
      value = var.airflow_jwt_secret
    },
    {
      name  = "AIRFLOW__CORE__AUTH_MANAGER"
      value = "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager"
    },
    {
      name  = "AIRFLOW__LOGGING__REMOTE_LOGGING"
      value = "True"
    },
    {
      name  = "AIRFLOW__LOGGING__REMOTE_BASE_LOG_FOLDER"
      value = "s3://${var.s3_bucket_name}/logs"
    },
    {
      name  = "AIRFLOW__LOGGING__REMOTE_LOG_CONN_ID"
      value = "aws_logs"
    },
    {
      name  = "AIRFLOW__LOGGING__ENCRYPT_S3_LOGS"
      value = "True"
    },
    {
      name  = "AIRFLOW_CONN_AWS_LOGS"
      value = "aws://@/?region_name=${var.aws_region}"
    }
  ]
}
