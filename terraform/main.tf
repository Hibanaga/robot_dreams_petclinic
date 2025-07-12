provider "aws" {
  region = var.region_id
}

module "vpc" {
  source = "./modules/vpc"
  aws_region_id = var.region_id
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "rds" {
  source = "./modules/rds"

  name                   = "monitoring-rds"
  vpc_security_group_ids = [module.security_groups.monitoring_security_group_id]
  db_subnet_group_name   = module.vpc.rds_subnet_group_name
}

module "ec2" {
  source = "./modules/ec2"

  aws_ec2_ami             = "ami-00c8ac9147e19828e"

  aws_ec2_web_instance_type   = "t3.micro"
  aws_ec2_monitoring_instance_type = "t3.small"

  aws_subnet_id           = module.vpc.public_subnet_id

  web_security_group_id        = module.security_groups.web_security_group_id
  monitoring_security_group_id = module.security_groups.monitoring_security_group_id
}