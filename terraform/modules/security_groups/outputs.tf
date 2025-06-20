output "public_ec2_security_group_id" {
  value = aws_security_group.public_ec2_security_group.id
}

output "private_ec2_security_group_id" {
  value = aws_security_group.private_ec2_security_group.id
}