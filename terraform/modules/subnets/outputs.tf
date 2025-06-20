output "subnet_ids" {
  value = { for key, value in aws_subnet.this : key => value.id }
}