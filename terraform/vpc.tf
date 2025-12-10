module "vpc" {
  source = "./modules/vpc"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.2.0/24","10.0.3.0/24"]
  public_subnets  = ["10.0.1.0/24","10.0.4.0/24"]


  enable_nat_gateway = true
  single_nat_gateway = true
  manage_default_security_group = false
  
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-service-sg"
  description = "Allow ALB to access ECS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Traffic from ALB to ECS"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

