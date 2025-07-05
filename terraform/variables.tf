variable "region_id" {
  type        = string
  default     = "eu-north-1"
}

variable "ec2_ami_id" {
  type        = string
  default     = "ami-00c8ac9147e19828e"
}

variable "ec2_type" {
  type        = string
  default     = "t3.micro"
}