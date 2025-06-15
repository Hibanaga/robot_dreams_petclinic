provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/VPC"
}

resource "aws_db_subnet_group" "library" {
  name       = "library-db-subnet-group"
  subnet_ids = [
    module.vpc.public_subnet1_id,
    module.vpc.public_subnet2_id
  ]

  tags = {
    Name = "Library DB subnet group"
  }
}

resource "aws_security_group" "library-db-security-group" {
  name   = "library-db-security-group"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.local_ip]
  }

  tags = {
    Name = "library-db-security-group"
  }
}

resource "aws_db_instance" "library-db" {
  identifier               = "library-db"
  engine                   = "mysql"
  engine_version           = "8.0"
  instance_class           = "db.t3.micro"
  allocated_storage        = 20
  db_name                  = var.db_name
  username                 = var.root_user
  password                 = var.root_password
  publicly_accessible      = true
  skip_final_snapshot      = true
  storage_type             = "gp2"
  vpc_security_group_ids   = [aws_security_group.library-db-security-group.id]
  db_subnet_group_name     = aws_db_subnet_group.library.name

  backup_retention_period = 7
  monitoring_interval = 60
  monitoring_role_arn = "arn:aws:iam::602682890304:role/rds-monitoring-role"

  tags = {
    Name = "library-db"
  }
}
