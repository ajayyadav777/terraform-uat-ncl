output "api_service_name" {
  value = aws_ecs_service.api.name
}

output "scheduler_service_name" {
  value = aws_ecs_service.scheduler.name
}

output "dag_processor_service_name" {
  value = aws_ecs_service.dag_processor.name
}

output "worker_service_name" {
  value = aws_ecs_service.worker.name
}

output "triggerer_service_name" {
  value = aws_ecs_service.triggerer.name
}

output "api_task_definition_arn" {
  value = aws_ecs_task_definition.api.arn
}

output "init_task_definition_arn" {
  value = aws_ecs_task_definition.init.arn
}

output "task_role_arn" {
  value = aws_iam_role.task.arn
}

output "execution_role_arn" {
  value = aws_iam_role.execution.arn
}

output "api_service_discovery_arn" {
  value = aws_service_discovery_service.api.arn
}
