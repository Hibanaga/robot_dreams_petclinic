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

module "ec2" {
  source = "./modules/ec2"

  aws_ec2_ami = "ami-00c8ac9147e19828e"
  aws_ec2_instance_type = "t3.micro"

  aws_subnet_id = module.vpc.subnet_id

  web_security_group_id = module.security_groups.aws_web_security_group_id
  monitoring_security_group_id = module.security_groups.aws_monitoring_security_group_id
}