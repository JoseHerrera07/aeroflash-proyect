# Crea un par de llaves SSH para conectarse a la instancia EC2

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "main" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
  
  tags = {
    Name = "${local.name_prefix}-keypair"
  }
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0400"
}
