# Crea la base de datos PostgreSQL en RDS

resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-rds-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
  
  tags = {
    Name = "${local.name_prefix}-rds-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier = local.rds_name
  
  engine         = "postgres"
  engine_version = var.rds_engine_version
  
  instance_class    = var.rds_instance_class
  allocated_storage = var.rds_allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true
  
  db_name  = var.rds_database_name
  username = var.rds_username
  password = random_password.rds_password.result
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
  
  backup_retention_period = var.rds_backup_retention_period
  backup_window           = var.rds_backup_window
  maintenance_window      = var.rds_maintenance_window
  
  auto_minor_version_upgrade = true
  
  multi_az = false
  
  skip_final_snapshot       = var.rds_skip_final_snapshot
  final_snapshot_identifier = "${local.rds_name}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  
  deletion_protection = false
  
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  
  max_allocated_storage = 100
  
  tags = {
    Name = local.rds_name
  }
  
  depends_on = [aws_security_group.rds]
}

resource "aws_secretsmanager_secret" "rds_password" {
  name        = "${local.name_prefix}-rds-password-${random_id.bucket_suffix.hex}"
  description = "Contraseña para la base de datos RDS PostgreSQL"
  
  tags = {
    Name = "${local.name_prefix}-rds-password"
  }
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id = aws_secretsmanager_secret.rds_password.id
  secret_string = jsonencode({
    username = var.rds_username
    password = random_password.rds_password.result
    engine   = "postgres"
    host     = aws_db_instance.main.address
    port     = aws_db_instance.main.port
    dbname   = var.rds_database_name
  })
}
