locals {
  create_db_instance     = true
  create_db_subnet_group = true
  create_db_parameter    = false
}

# -------------------------
# RDS Subnet Group Module
# -------------------------
module "db_subnet_group" {
  source = "./modules/rds/db_subnet_group"

  create       = local.create_db_subnet_group
  name         = "${var.project}-db-subnet-group"
  subnet_ids   = module.vpc.private_subnets
  description  = "DB Subnet Group"
  tags         = var.tags
}

# -------------------------
# RDS Security Group
# -------------------------
resource "aws_security_group" "rds_sg" {
  name        = "${var.project}-rds-sg"
  description = "Allow ECS to access RDS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "MySQL from ECS"
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------
# RDS Instance Module
# -------------------------
resource "aws_db_instance" "mysql" {
  identifier             = "mydb"
  allocated_storage      = 20
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"   # Free-tier eligible
  username               = var.DB_USER
  password               = var.DB_PASS
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  storage_type      = "gp3"

  db_subnet_group_name = module.db_subnet_group.db_subnet_group_id
  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  publicly_accessible = false

  tags = var.tags
}
