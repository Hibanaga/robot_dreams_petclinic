resource "aws_instance" "ec2_monitoring" {
  ami = var.aws_ec2_ami
  instance_type = var.aws_ec2_monitoring_instance_type

  subnet_id = var.aws_subnet_id

  vpc_security_group_ids = [
    var.monitoring_security_group_id
  ]
  associate_public_ip_address = true

  key_name = "rsa-keygen-north"

  tags = {
    Name = "monitoring-server"
  }
}

resource "aws_instance" "ec2_web" {
  ami = var.aws_ec2_ami
  instance_type = var.aws_ec2_web_instance_type

  subnet_id = var.aws_subnet_id

  vpc_security_group_ids = [
    var.web_security_group_id
  ]
  associate_public_ip_address = true

  tags = {
    Name = "web-server"
  }
}