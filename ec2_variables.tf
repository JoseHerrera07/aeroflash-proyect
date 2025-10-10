# Variables específicas para la instancia EC2

variable "ec2_instance_type" {
  description = "Tipo de instancia EC2 (t2.micro = gratis en free tier)"
  type        = string
  default     = "t2.micro"
}

variable "ec2_ami" {
  description = "ID de la AMI de Ubuntu 22.04 LTS para EC2"
  type        = string
  default     = "ami-0c02fb55b34d4e326"
}

variable "ec2_root_volume_size" {
  description = "Tamaño del volumen raíz en GB"
  type        = number
  default     = 20
}

variable "ec2_root_volume_type" {
  description = "Tipo de volumen EBS (gp3 = SSD de propósito general)"
  type        = string
  default     = "gp3"
}
