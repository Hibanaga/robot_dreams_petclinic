subnets = {
  "public-1" = {
    cidr_block = "10.0.1.0/24"
    aviability_zone = "eu-north-1a"
    public = true
  }
  "private-1" = {
    cidr_block = "10.0.2.0/24"
    aviability_zone = "eu-north-1b"
    public = false
  }
}

instances = {
  "public-server" = {
    ami = "ami-05fcfb9614772f051"
    instance_type = "t3.micro"
    subnet_key = "public-1"
    public = true
    key_name = "europe-stockholm-ssh-rsa-keygen"
  }
  "private-server" = {
    ami = "ami-05fcfb9614772f051"
    instance_type = "t3.micro"
    subnet_key = "private-1"
    public = false
    key_name = "europe-stockholm-ssh-rsa-keygen"
  }
}