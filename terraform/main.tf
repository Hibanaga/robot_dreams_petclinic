provider "aws" {
  region = var.instance_region_id
}

resource "aws_vpc" "ansible_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ansible-demo-vpc"
  }
}

resource "aws_key_pair" "europe_stockholm_key" {
  key_name   = "europe-stockholm-ssh-rsa-keygen"
  public_key = file("../ssh-keys/europe-stockholm-ssh-rsa-keygen.pub")
}

resource "aws_internet_gateway" "ansible_gateway" {
  vpc_id = aws_vpc.ansible_vpc.id

  tags = {
    Name = "ansible-gateway"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.ansible_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "ansible-public-subnet"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.ansible_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ansible_gateway.id
  }

  tags = {
    Name = "ansible-public-route-table"
  }
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "ansible_access" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.ansible_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "ansible-access"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-00c8ac9147e19828e"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ansible_access.id]

  key_name = aws_key_pair.europe_stockholm_key.key_name

  tags = {
    Name        = "ansible-demo"
    Environment = "development"
  }
}
