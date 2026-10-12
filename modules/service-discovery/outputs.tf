output "namespace_id" {
  value = aws_service_discovery_private_dns_namespace.this.id
}

output "namespace_arn" {
  value = aws_service_discovery_private_dns_namespace.this.arn
}

output "namespace_name" {
  value = aws_service_discovery_private_dns_namespace.this.name
}

output "elasticsearch_service_id" {
  value = aws_service_discovery_service.elasticsearch.id
}

output "elasticsearch_service_name" {
  value = "elasticsearch.${aws_service_discovery_private_dns_namespace.this.name}"
}
