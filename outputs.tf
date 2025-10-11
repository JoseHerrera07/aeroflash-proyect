# Outputs generales del proyecto

output "infrastructure_summary" {
  description = "Resumen completo de la infraestructura creada"
  value = {
    project     = var.project_name
    environment = var.environment
    region      = var.aws_region
    created_at  = timestamp()
  }
}

output "connection_instructions" {
  description = "Instrucciones para conectarse a la infraestructura"
  value = <<-EOT
    
    ╔════════════════════════════════════════════════════════════════╗
    ║          INFRAESTRUCTURA CREADA EXITOSAMENTE                   ║
    ╚════════════════════════════════════════════════════════════════╝
    
    📋 INFORMACIÓN DE ACCESO:
    ─────────────────────────────────────────────────────────────────
    
    🖥️  EC2 Instance:
       IP Pública: ${aws_eip.main.public_ip}
       SSH: ssh -i ${var.key_name}.pem ubuntu@${aws_eip.main.public_ip}
    
    🌐 URLs de Aplicación:
       Frontend:  http://${aws_eip.main.public_ip}
       Backend:   http://${aws_eip.main.public_ip}:5000
       Grafana:   http://${aws_eip.main.public_ip}:3000
    
    🗄️  Base de Datos PostgreSQL:
       Host:      ${aws_db_instance.main.address}
       Puerto:    ${aws_db_instance.main.port}
       Database:  ${var.rds_database_name}
       Usuario:   ${var.rds_username}
       Contraseña: (ejecutar: terraform output -raw rds_password)
    
    📦 Bucket S3:
       Nombre:    ${aws_s3_bucket.main.id}
       Website:   http://${aws_s3_bucket_website_configuration.main.website_endpoint}
    
    ─────────────────────────────────────────────────────────────────
    
    ⚡ PRÓXIMOS PASOS:
    
    1. Conectarse a EC2:
       chmod 400 ${var.key_name}.pem
       ssh -i ${var.key_name}.pem ubuntu@${aws_eip.main.public_ip}
    
    2. Verificar instalación de Docker:
       docker --version
       docker-compose --version
    
    3. Configurar variables de entorno con credenciales de RDS
    
    4. Desplegar aplicación con Docker Compose
    
    5. Subir archivos estáticos a S3:
       aws s3 cp ./static/ s3://${aws_s3_bucket.main.id}/ --recursive
    
    ─────────────────────────────────────────────────────────────────
    
    ⚠️  IMPORTANTE - SEGURIDAD:
    - Cambiar my_ip en terraform.tfvars por tu IP real
    - Guardar la llave .pem en un lugar seguro
    - No compartir la contraseña de RDS
    - Configurar SSL/HTTPS en producción
    
    ─────────────────────────────────────────────────────────────────
  EOT
  sensitive = true
}

output "database_credentials" {
  description = "Credenciales de la base de datos (usar con precaución)"
  value = {
    host     = aws_db_instance.main.address
    port     = aws_db_instance.main.port
    database = var.rds_database_name
    username = var.rds_username
    password = random_password.rds_password.result
  }
  sensitive = true
}

output "database_url_env" {
  description = "Variable de entorno DATABASE_URL para tu aplicación"
  value       = "DATABASE_URL=postgresql://${var.rds_username}:${random_password.rds_password.result}@${aws_db_instance.main.address}:${aws_db_instance.main.port}/${var.rds_database_name}"
  sensitive   = true
}
