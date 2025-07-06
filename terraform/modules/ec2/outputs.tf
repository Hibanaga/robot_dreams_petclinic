output "monitoring_server_public_ip" {
  value = aws_instance.ec2_monitoring.public_ip
}

output "web_server_server_ip" {
  value = aws_instance.ec2_web.public_ip
}