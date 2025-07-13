
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

  tags = {
    Name = var.name
  }
}
