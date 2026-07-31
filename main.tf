terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configuração do Provedor AWS
provider "aws" {
  region = "us-east-1" # Região elegível para o Free Tier
}

# Busca a AMI mais recente do Amazon Linux 2023 (Elegível para o Free Tier)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # ID da Canonical

  filter {
    name   = "name"
    values = [ "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Criação da Instância EC2
resource "aws_instance" "web_free_tier" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro" # Tipo obrigatório para o Free Tier

  tags = {
    Name = "EC2-Free-Tier-Terraform"
  }
}

# Output para exibir o IP público da instância
output "instance_public_ip" {
  value       = aws_instance.web_free_tier.public_ip
  description = "O endereço IP público da instância EC2"
}

