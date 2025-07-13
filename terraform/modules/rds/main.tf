resource "aws_db_parameter_group" "mysql_logging" {
  name        = "${var.name}-param-group"
  family      = "mysql8.0"
  description = "Custom MySQL 8.0 parameter group with logging enabled"

  parameter {
    name  = "general_log"
    value = "1"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = "1"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }

  tags = {
    Name = "${var.name}-param-group"
  }
}

resource "aws_db_instance" "this" {
  identifier              = var.name
  engine                  = "mysql"
  engine_version          = "8.0.41"
  instance_class          = "db.t4g.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  username                = "admin"
  password                = "securePass1"
  db_name                 = "monitoring"
  port                    = 3306
  publicly_accessible     = false
  multi_az                = false
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = var.db_subnet_group_name
  skip_final_snapshot     = true
  deletion_protection     = false

  parameter_group_name = aws_db_parameter_group.mysql_logging.name

  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  tags = {
    Name = var.name
  }
}
