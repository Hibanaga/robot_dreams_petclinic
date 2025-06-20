variable "subnets" {
  type = map(object({
    cidr_block = string
    aviability_zone = string
    public = bool
  }))
}

variable "instances" {
  type = map(object({
    ami = string
    instance_type = string
    subnet_key = string
    public = bool
  }))
}