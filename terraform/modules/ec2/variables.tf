variable "subnet_ids" {
  type = map(string)
}

variable "instances" {
  type = map(object({
    ami = string
    instance_type = string
    subnet_key = string
    public = bool
    key_name = string
  }))
}

variable "public_ec2_security_group_id" {
  type = string
}

variable "private_ec2_security_group_id" {
  type = string
}