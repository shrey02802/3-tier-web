################################################################################
# ECS Security Group
################################################################################

resource "aws_security_group" "ecs" {
  count = var.create_ecs_sg ? 1 : 0

  name        = var.ecs_sg_name
  description = var.ecs_sg_description
  vpc_id      = var.vpc_id

  ingress {
    description     = "Traffic from ALB to ECS"
    from_port       = var.ecs_port
    to_port         = var.ecs_port
    protocol        = "tcp"
    security_groups = var.alb_security_group_id != null ? [var.alb_security_group_id] : []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = var.ecs_sg_name },
    var.tags
  )
}

################################################################################
# ALB Security Group
################################################################################

resource "aws_security_group" "alb" {
  count = var.create_alb_sg ? 1 : 0

  name        = var.alb_sg_name
  description = var.alb_sg_description
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = var.alb_sg_name },
    var.tags
  )
}

################################################################################
# RDS Security Group
################################################################################

resource "aws_security_group" "rds" {
  count = var.create_rds_sg ? 1 : 0

  name        = var.rds_sg_name
  description = var.rds_sg_description
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from ECS"
    protocol        = "tcp"
    from_port       = var.rds_port
    to_port         = var.rds_port
    security_groups = var.ecs_security_group_id != null ? [var.ecs_security_group_id] : []
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = var.rds_sg_name },
    var.tags
  )
}

