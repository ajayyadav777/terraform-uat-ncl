############################################################
# Elasticsearch Cloud Map Service
############################################################

resource "aws_service_discovery_service" "elasticsearch" {

  name = "elasticsearch"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.this.id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  tags = local.common_tags
}


############################################################
# Register Elasticsearch EC2 instance
############################################################

resource "aws_service_discovery_instance" "elasticsearch" {

  service_id = aws_service_discovery_service.elasticsearch.id

  instance_id = "elasticsearch-01"

  attributes = {
    AWS_INSTANCE_IPV4 = var.elasticsearch_private_ip
  }
}
