output "monitoring_security_group_id" {
  value = aws_security_group.monitoring_security_group.id
}

output "web_security_group_id" {
  value = aws_security_group.web_security_group.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds_security_group.id
}