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

# Busca a AMI mais recente do Ubuntu 24.04 LTS (Elegível para o Free Tier)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # ID da Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 1. Registro da Chave SSH Pública na AWS
resource "aws_key_pair" "ansible_key" {
  key_name   = "ansible-ec2-key"
  public_key = file("~/.ssh/diogogarbintrabalho-hue.pub")
}

# 2. Security Group para permitir SSH (22) e HTTP (80)
resource "aws_security_group" "web_ansible_sg" {
  name        = "ansible_web_access"
  description = "Permite acesso SSH para o Ansible e HTTP para aplicacoes web"

  # Entrada: Porta 22 (SSH) para conexao do Ansible
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Entrada: Porta 80 (HTTP) para acessar aplicacoes como Nginx
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Saida: Libera todo o tráfego de saída para a EC2 conseguir baixar pacotes na internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Ansible-Web"
  }
}

# Criação da Instância EC2
resource "aws_instance" "web_free_tier" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ansible_key.key_name
  vpc_security_group_ids = [aws_security_group.web_ansible_sg.id]

  tags = {
    Name = "EC2-Free-Tier-Terraform"
  }
}

# Output para exibir o IP público da instância
output "instance_public_ip" {
  value       = aws_instance.web_free_tier.public_ip
  description = "O endereço IP público da instância EC2"
}
