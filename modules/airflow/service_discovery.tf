resource "aws_service_discovery_service" "api" {

  name = "airflow-api"

  dns_config {
    namespace_id = var.airflow_namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  tags = local.common_tags
}
