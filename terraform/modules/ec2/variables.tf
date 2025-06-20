variable "subnet_ids" {
  type = map(string)
}

variable "instances" {
  type = map(object({
    ami = string
    instance_type = string
    subnet_key = string
    public = bool
  }))
}