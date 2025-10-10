# s3_variables.tf
# Variables específicas para el bucket S3

variable "s3_versioning_enabled" {
  description = "Habilitar versionado de objetos (mantiene historial de cambios)"
  type        = bool
  default     = true
}

variable "s3_encryption_enabled" {
  description = "Habilitar encriptación de objetos en reposo"
  type        = bool
  default     = true
}

variable "s3_lifecycle_enabled" {
  description = "Habilitar reglas de ciclo de vida para gestionar objetos antiguos"
  type        = bool
  default     = false
}

variable "s3_transition_days" {
  description = "Días antes de mover objetos a S3 Intelligent-Tiering"
  type        = number
  default     = 90
}

variable "s3_expiration_days" {
  description = "Días antes de eliminar versiones antiguas de objetos"
  type        = number
  default     = 365
}

variable "s3_block_public_access" {
  description = "Bloquear todo acceso público al bucket"
  type        = bool
  default     = false
}
