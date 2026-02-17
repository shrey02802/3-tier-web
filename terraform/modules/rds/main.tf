################################################################################
# RDS Subnet Group
################################################################################

resource "aws_db_subnet_group" "this" {
  count = var.create_db_subnet_group ? 1 : 0

  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_ids

  tags = merge(
    { Name = var.db_subnet_group_name },
    var.tags
  )
}

################################################################################
# RDS Instance
################################################################################

resource "aws_db_instance" "this" {
  identifier             = var.identifier
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.username
  password               = var.password
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = var.skip_final_snapshot
  storage_type           = var.storage_type

  db_subnet_group_name = var.create_db_subnet_group ? aws_db_subnet_group.this[0].name : var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids

  publicly_accessible = var.publicly_accessible

  tags = var.tags
}

