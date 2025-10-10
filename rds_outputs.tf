# rds_outputs.tf
# Outputs relacionados con RDS

output "rds_endpoint" {
  description = "Endpoint de conexión para PostgreSQL"
  value       = aws_db_instance.main.endpoint
}

output "rds_address" {
  description = "Dirección del host de la base de datos"
  value       = aws_db_instance.main.address
}

output "rds_port" {
  description = "Puerto de conexión de PostgreSQL"
  value       = aws_db_instance.main.port
}

output "rds_database_name" {
  description = "Nombre de la base de datos"
  value       = aws_db_instance.main.db_name
}

output "rds_username" {
  description = "Usuario administrador de la base de datos"
  value       = var.rds_username
  sensitive   = true
}

output "rds_password" {
  description = "Contraseña de la base de datos (usar con cuidado)"
  value       = random_password.rds_password.result
  sensitive   = true
}

output "rds_connection_string" {
  description = "String de conexión para PostgreSQL"
  value       = "postgresql://${var.rds_username}:${random_password.rds_password.result}@${aws_db_instance.main.address}:${aws_db_instance.main.port}/${var.rds_database_name}"
  sensitive   = true
}

output "rds_secret_arn" {
  description = "ARN del secreto de RDS en AWS Secrets Manager"
  value       = aws_secretsmanager_secret.rds_password.arn
}
