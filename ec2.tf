#Crea la instancia EC2 que ejecutará Docker y tus aplicaciones
 
locals {
  user_data = <<-EOF
    #!/bin/bash
    exec > >(tee -a /var/log/user-data.log)
    exec 2>&1
    
    echo "Iniciando configuración de EC2 - $(date)"
    
    # Actualizar sistema
    apt-get update -y
    apt-get upgrade -y
    
    # Instalar Docker
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io
    
    # Instalar Docker Compose
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    
    # Dar permisos al usuario ubuntu
    usermod -aG docker ubuntu
    
    # Instalar herramientas útiles
    apt-get install -y git htop curl wget unzip postgresql-client awscli
    
    # Crear directorio para la aplicación
    mkdir -p /home/ubuntu/flight-booking
    chown -R ubuntu:ubuntu /home/ubuntu/flight-booking
    
    # Habilitar Docker
    systemctl enable docker
    systemctl start docker
    
    echo "Instalación completada - $(date)" > /home/ubuntu/setup-complete.txt
  EOF
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  
  key_name = aws_key_pair.main.key_name
  
  vpc_security_group_ids = [aws_security_group.ec2.id]
  
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  
  user_data = local.user_data
  
  user_data_replace_on_change = true
  
  root_block_device {
    volume_size           = var.ec2_root_volume_size
    volume_type           = var.ec2_root_volume_type
    delete_on_termination = true
    
    tags = {
      Name = "${local.name_prefix}-ec2-volume"
    }
  }
  
  monitoring = false
  
  tags = {
    Name = local.ec2_name
  }
}

resource "aws_eip" "main" {
  instance = aws_instance.main.id
  domain   = "vpc"
  
  tags = {
    Name = "${local.name_prefix}-eip"
  }
  
  depends_on = [aws_instance.main]
}
