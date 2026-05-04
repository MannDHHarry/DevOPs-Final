terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

# ── Security Group ───────────────────────────────────────────
resource "aws_security_group" "devops_final_sg" {
  name        = "devops-final-sg"
  description = "Allow web, SSH, and monitoring traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-final-sg"
  }
}

# ── EC2 Instance ─────────────────────────────────────────────
resource "aws_instance" "devops_final_server" {
  ami                    = "ami-0df7a207adb9748c7"
  instance_type          = "t3.micro"
  key_name               = "devops-final-key"
  vpc_security_group_ids = [aws_security_group.devops_final_sg.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name = "devops-final-server"
  }
}

# ── Outputs ──────────────────────────────────────────────────
output "server_public_ip" {
  description = "EC2 public IP — share with your team"
  value       = aws_instance.devops_final_server.public_ip
}

output "ssh_command" {
  description = "Ready-to-use SSH command"
  value       = "ssh -i keys/devops-final-key.pem ubuntu@${aws_instance.devops_final_server.public_ip}"
}