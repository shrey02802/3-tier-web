################################################################################
# CloudWatch Log Group
################################################################################

resource "aws_cloudwatch_log_group" "this" {
  count = var.create_cloudwatch_log_group ? 1 : 0

  name              = var.cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_log_group_retention_in_days

  tags = merge(
    { Name = var.cloudwatch_log_group_name },
    var.tags
  )
}

################################################################################
# ECS Cluster
################################################################################

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  tags = merge(
    { Name = var.cluster_name },
    var.tags
  )
}

################################################################################
# Task Definition
################################################################################

locals {
  # Convert container_definitions to array format if it's a map
  container_definitions_array = can(var.container_definitions[0]) ? var.container_definitions : [for k, v in var.container_definitions : v]
}

resource "aws_ecs_task_definition" "this" {
  count = var.create_task_definition ? 1 : 0

  family                   = var.family
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory

  container_definitions = jsonencode(local.container_definitions_array)

  tags = var.tags
}

################################################################################
# ECS Service
################################################################################

resource "aws_ecs_service" "this" {
  count = var.create_service ? 1 : 0

  name            = var.service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = var.create_task_definition ? aws_ecs_task_definition.this[0].arn : var.task_definition_arn
  desired_count   = var.desired_count
  launch_type      = var.launch_type

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = var.load_balancer != null ? [var.load_balancer] : []
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }

  depends_on = [aws_ecs_task_definition.this]

  tags = var.tags
}

