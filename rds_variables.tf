# Variables específicas para la base de datos RDS PostgreSQL

variable "rds_instance_class" {
  description = "Clase de instancia RDS (db.t3.micro = más pequeña y económica)"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "Tamaño del almacenamiento en GB para RDS"
  type        = number
  default     = 20
}

variable "rds_engine_version" {
  description = "Versión de PostgreSQL"
  type        = string
  default     = "14.18"
}

variable "rds_database_name" {
  description = "Nombre de la base de datos inicial que se creará"
  type        = string
  default     = "flightbookingdb"
}

variable "rds_username" {
  description = "Usuario maestro para la base de datos"
  type        = string
  default     = "flightadmin"
  sensitive   = true
}

variable "rds_backup_retention_period" {
  description = "Días para retener backups automáticos (0 = deshabilitado)"
  type        = number
  default     = 7
}

variable "rds_maintenance_window" {
  description = "Ventana de mantenimiento preferida (UTC)"
  type        = string
  default     = "sun:03:00-sun:04:00"
}

variable "rds_backup_window" {
  description = "Ventana de backup diario preferida (UTC)"
  type        = string
  default     = "02:00-03:00"
}

variable "rds_skip_final_snapshot" {
  description = "Saltar snapshot final al eliminar (solo para desarrollo)"
  type        = bool
  default     = true
}
