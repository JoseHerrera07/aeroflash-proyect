# Define todas las variables generales del proyecto

variable "project_name" {
  description = "Nombre del proyecto, se usará como prefijo en los recursos"
  type        = string
  default     = "flight-booking"
}

variable "environment" {
  description = "Ambiente de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "owner" {
  description = "Nombre del dueño o equipo responsable del proyecto"
  type        = string
  default     = "DevOps Team"
}

variable "my_ip" {
  description = "Tu dirección IP pública para acceso SSH (formato: x.x.x.x/32)"
  type        = string
  default     = "0.0.0.0/0"  # CAMBIAR por tu IP real para mayor seguridad
}

variable "key_name" {
  description = "Nombre para el par de llaves SSH"
  type        = string
  default     = "flight-booking-key"
}
