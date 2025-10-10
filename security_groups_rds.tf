# Security Group para la base de datos RDS

resource "aws_security_group" "rds" {
  name        = "${local.name_prefix}-rds-sg"
  description = "Security group para RDS PostgreSQL - solo acceso desde EC2"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "PostgreSQL desde EC2"
    from_port       = local.allowed_ports.postgres
    to_port         = local.allowed_ports.postgres
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    description = "Permite todo el trafico saliente"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-rds-sg"
  }
}
