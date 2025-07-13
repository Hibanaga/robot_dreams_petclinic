output "region_id" {
  value = var.region_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "monitoring_ec2_ip" {
  value = module.ec2.monitoring_server_public_ip
}

output "web_ec2_ip" {
  value = module.ec2.web_server_server_ip
}

output "rds_endpoint" {
  value = module.rds.endpoint
}