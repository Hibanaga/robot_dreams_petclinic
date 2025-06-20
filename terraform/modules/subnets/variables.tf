variable "subnets" {
  type = map(object({
    cidr_block = string
    aviability_zone = string
    public = bool
  }))
}

variable "vpc_id" {
  type = string
}

variable "route_table_id" {
  type = string
}