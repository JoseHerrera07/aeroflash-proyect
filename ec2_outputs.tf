# ec2_outputs.tf
# Outputs relacionados con EC2

output "ec2_public_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = aws_eip.main.public_ip
}

output "ec2_instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.main.id
}

output "frontend_url" {
  description = "URL para acceder al frontend de la aplicación"
  value       = "http://${aws_eip.main.public_ip}"
}

output "backend_url" {
  description = "URL para acceder al backend API"
  value       = "http://${aws_eip.main.public_ip}:5000"
}

output "grafana_url" {
  description = "URL para acceder a Grafana"
  value       = "http://${aws_eip.main.public_ip}:3000"
}

output "ssh_command" {
  description = "Comando para conectarse a EC2 por SSH"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_eip.main.public_ip}"
}
