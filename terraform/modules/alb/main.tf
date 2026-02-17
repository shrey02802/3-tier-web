################################################################################
# Application Load Balancer
################################################################################

resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = var.security_group_ids

  tags = merge(
    { Name = var.name },
    var.tags
  )
}

################################################################################
# Target Group
################################################################################

resource "aws_lb_target_group" "this" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id

  health_check {
    path                = var.health_check_path
    protocol            = var.health_check_protocol
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
  }

  tags = merge(
    { Name = var.target_group_name },
    var.tags
  )
}

################################################################################
# Listener
################################################################################

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

