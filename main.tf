provider "aws" {
  region = "us-east-1" # Asegúrate que esta sea tu región
  # NO PONGAS TUS CREDENTIALS AQUÍ (Te explico en el Paso 4)
}

resource "aws_security_group" "monitoring_sg" {
  name        = "monitoring-sg"
  description = "Security group for Monitoring Project"

  # SSH (Para que entres tú)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Grafana Dashboard
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Aplicación Backend (FastAPI)
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Prometheus (Opcional: para ver que scrapea bien)
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Salida a internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0e2c8caa4b6378d8c" # Ubuntu 24.04 (Verifica si es correcta en tu región us-east-1)
  instance_type = "t3.medium" # Usamos medium para que soporte Docker, Loki y Grafana juntos
  key_name      = "flight-booking-key"    # <--- CAMBIA ESTO POR EL NOMBRE DE TU KEY PAIR EN AWS (ej. "vockey" o el que tengas)
  vpc_security_group_ids = [aws_security_group.monitoring_sg.id]

  # Esto instala Docker automáticamente al crear la máquina
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io docker-compose git
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu
              EOF

  tags = {
    Name = "Servidor-Monitoreo-Proyecto"
  }
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}