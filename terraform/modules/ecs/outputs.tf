output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.this.id
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.this.arn
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.this.name
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = var.create_task_definition ? aws_ecs_task_definition.this[0].arn : null
}

output "service_id" {
  description = "ID of the ECS service"
  value       = var.create_service ? aws_ecs_service.this[0].id : null
}

output "service_name" {
  description = "Name of the ECS service"
  value       = var.create_service ? aws_ecs_service.this[0].name : null
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group name"
  value       = var.create_cloudwatch_log_group ? aws_cloudwatch_log_group.this[0].name : null
}

