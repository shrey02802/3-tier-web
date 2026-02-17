output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.this.arn
}

output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_address" {
  description = "RDS instance address"
  value       = aws_db_instance.this.address
}

output "db_subnet_group_id" {
  description = "DB subnet group ID"
  value       = var.create_db_subnet_group ? aws_db_subnet_group.this[0].id : null
}

output "db_subnet_group_name" {
  description = "DB subnet group name"
  value       = var.create_db_subnet_group ? aws_db_subnet_group.this[0].name : var.db_subnet_group_name
}

