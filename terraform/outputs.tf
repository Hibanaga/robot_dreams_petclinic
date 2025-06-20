output "vpc_id" {
  value = module.vpc.vpc_id
}

output "route_table_id" {
  value = module.vpc.public_route_table_id
}

output "subnet_ids" {
  value = [for key, value in module.subnets.subnet_ids : value if var.subnets[key].public]
}

output "instance_ids" {
  value = [ for key, value in module.ec2.instance_ids : value if var.instances[key].public ]
}