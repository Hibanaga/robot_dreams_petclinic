
provider "aws" {
  region = "eu-north-1"
}

resource "aws_vpc" "imported_vpc" {
  tags = {
    Name = "advanced-terraform-vpc"
  }
}

resource "aws_subnet" "imported_public_subnet_1" {
  vpc_id = aws_vpc.imported_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 1"
  }
}
resource "aws_subnet" "imported_private_subnet_1" {
  vpc_id = aws_vpc.imported_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Private Subnet 1"
  }
}

resource "aws_route_table" "imported_route_table" {
  vpc_id = aws_vpc.imported_vpc.id
  tags = {
    Name = "advanced-terraform-public-route-table"
  }
}

resource "aws_internet_gateway" "imported_internet_gateway" {
  tags = {
    Name = "advanced-terraform-gateway"
  }
}

resource "aws_instance" "imported_public_server" {
  ami = "ami-05fcfb9614772f051"
  instance_type = "t3.micro"
  key_name = "europe-stockholm-ssh-rsa-keygen"
  tags = {
    Name = "public-server"
  }
}

resource "aws_instance" "imported_private_server" {
  ami = "ami-05fcfb9614772f051"
  instance_type = "t3.micro"
  key_name = "europe-stockholm-ssh-rsa-keygen"
  tags = {
    Name = "private-server"
  }
}

resource "aws_security_group" "public_ec2_security_group" {
  vpc_id = aws_vpc.imported_vpc.id
}

resource "aws_security_group" "private_ec2_security_group" {
  vpc_id = aws_vpc.imported_vpc.id
}