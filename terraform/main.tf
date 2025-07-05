provider "aws" {
  region = var.region_id
}

resource "tls_private_key" "generated" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  filename = "${path.module}/private_key.pem"
  content  = tls_private_key.generated.private_key_pem
  file_permission = "0600"
}

resource "local_file" "public_key" {
  filename = "${path.module}/public_key.pub"
  content  = tls_private_key.generated.public_key_openssh
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ec2_access" {
  name        = "allow_ssh_jenkins"
  description = "Allow SSH and port 8080"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "generated" {
  key_name   = "jenkins-ec2-key"
  public_key = tls_private_key.generated.public_key_openssh
}

resource "aws_instance" "ec2" {
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_access.id]
  key_name               = aws_key_pair.generated.key_name

  tags = {
    Name = "jenkins-ec2"
  }
}