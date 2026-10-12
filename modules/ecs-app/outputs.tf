output "frontend_service_name" {
  value = aws_ecs_service.frontend.name
}

output "backend_service_name" {
  value = aws_ecs_service.backend.name
}

output "frontend_task_definition_arn" {
  value = aws_ecs_task_definition.frontend.arn
}

output "backend_task_definition_arn" {
  value = aws_ecs_task_definition.backend.arn
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution.arn
}

output "frontend_log_group" {
  value = aws_cloudwatch_log_group.frontend.name
}

output "backend_log_group" {
  value = aws_cloudwatch_log_group.backend.name
}
