provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  name = "advanced-terraform"
}

module "subnets" {
  source = "./modules/subnets"
  vpc_id = module.vpc.vpc_id
  route_table_id = module.vpc.public_route_table_id
  subnets = var.subnets
}

module "ec2_security_group" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
  name = "advanced-terraform"
}

module "ec2" {
  source = "./modules/ec2"
  subnet_ids = module.subnets.subnet_ids

  instances = var.instances

  public_ec2_security_group_id = module.ec2_security_group.public_ec2_security_group_id
  private_ec2_security_group_id = module.ec2_security_group.private_ec2_security_group_id
}