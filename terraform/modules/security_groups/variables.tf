variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "create_ecs_sg" {
  description = "Create ECS security group"
  type        = bool
  default     = true
}

variable "ecs_sg_name" {
  description = "Name of ECS security group"
  type        = string
  default     = "ecs-service-sg"
}

variable "ecs_sg_description" {
  description = "Description of ECS security group"
  type        = string
  default     = "Allow ALB to access ECS"
}

variable "ecs_port" {
  description = "Port for ECS service"
  type        = number
  default     = 3000
}

variable "alb_security_group_id" {
  description = "ALB security group ID for ECS ingress"
  type        = string
  default     = null
}

variable "create_alb_sg" {
  description = "Create ALB security group"
  type        = bool
  default     = true
}

variable "alb_sg_name" {
  description = "Name of ALB security group"
  type        = string
  default     = "alb-sg"
}

variable "alb_sg_description" {
  description = "Description of ALB security group"
  type        = string
  default     = "Security group for ALB"
}

variable "alb_ingress_cidr_blocks" {
  description = "CIDR blocks allowed to access ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "create_rds_sg" {
  description = "Create RDS security group"
  type        = bool
  default     = true
}

variable "rds_sg_name" {
  description = "Name of RDS security group"
  type        = string
  default     = "rds-sg"
}

variable "rds_sg_description" {
  description = "Description of RDS security group"
  type        = string
  default     = "Allow ECS to access RDS"
}

variable "rds_port" {
  description = "Port for RDS database"
  type        = number
  default     = 3306
}

variable "ecs_security_group_id" {
  description = "ECS security group ID for RDS ingress"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

