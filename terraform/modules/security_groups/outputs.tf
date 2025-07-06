output "aws_monitoring_security_group_id" {
  value = aws_security_group.monitoring_security_group.id
}

output "aws_web_security_group_id" {
  value = aws_security_group.web_security_group.id
}