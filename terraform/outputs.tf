output "rds_endpoint" {
  value = aws_db_instance.library-db.endpoint
}

output "rds_port" {
  value = aws_db_instance.library-db.port
}