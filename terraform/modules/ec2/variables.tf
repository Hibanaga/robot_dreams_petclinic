variable "aws_ec2_ami" {
  type = string
}

variable "aws_ec2_monitoring_instance_type" {
  type = string
}

variable "aws_ec2_web_instance_type" {
  type = string
}

variable "aws_subnet_id" {
  type = string
}

variable "web_security_group_id" {
  type = string
}

variable "monitoring_security_group_id" {
  type = string
}
