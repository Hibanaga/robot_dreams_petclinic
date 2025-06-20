output "instance_ids" {
  value = { for key,value in aws_instance.this : key => value.id }
}