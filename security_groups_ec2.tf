# Security Group para la instancia EC2

resource "aws_security_group" "ec2" {
  name        = "${local.name_prefix}-ec2-sg"
  description = "Security group para la instancia EC2 del sistema de reserva de vuelos"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH desde mi IP"
    from_port   = local.allowed_ports.ssh
    to_port     = local.allowed_ports.ssh
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "HTTP desde internet"
    from_port   = local.allowed_ports.http
    to_port     = local.allowed_ports.http
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Backend API"
    from_port   = local.allowed_ports.backend
    to_port     = local.allowed_ports.backend
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Grafana dashboard"
    from_port   = local.allowed_ports.grafana
    to_port     = local.allowed_ports.grafana
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Permite todo el trafico saliente"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-ec2-sg"
  }
}
