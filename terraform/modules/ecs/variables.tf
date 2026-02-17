variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "enable_container_insights" {
  description = "Enable container insights"
  type        = bool
  default     = false
}

variable "create_cloudwatch_log_group" {
  description = "Create CloudWatch log group"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "CloudWatch log group retention in days"
  type        = number
  default     = 7
}

variable "create_task_definition" {
  description = "Create task definition"
  type        = bool
  default     = true
}

variable "family" {
  description = "Task definition family"
  type        = string
}

variable "network_mode" {
  description = "Network mode"
  type        = string
  default     = "awsvpc"
}

variable "requires_compatibilities" {
  description = "Requires compatibilities"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "cpu" {
  description = "CPU units"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 512
}

variable "container_definitions" {
  description = "Container definitions"
  type        = any
}

variable "create_service" {
  description = "Create ECS service"
  type        = bool
  default     = true
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "task_definition_arn" {
  description = "Task definition ARN (if not creating one)"
  type        = string
  default     = null
}

variable "desired_count" {
  description = "Desired count of tasks"
  type        = number
  default     = 1
}

variable "launch_type" {
  description = "Launch type"
  type        = string
  default     = "FARGATE"
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign public IP"
  type        = bool
  default     = false
}

variable "load_balancer" {
  description = "Load balancer configuration"
  type = object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

