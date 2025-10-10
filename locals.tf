# Define valores locales que se calculan o combinan a partir de variables

locals {
  name_prefix = "${var.project_name}-${var.environment}"
  
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
    CreatedAt   = timestamp()
  }
  
  ec2_name = "${local.name_prefix}-ec2"
  rds_name = "${local.name_prefix}-rds"
  s3_name  = "${local.name_prefix}-s3-${random_id.bucket_suffix.hex}"
  
  allowed_ports = {
    ssh      = 22
    http     = 80
    backend  = 5000
    grafana  = 3000
    postgres = 5432
  }
}
