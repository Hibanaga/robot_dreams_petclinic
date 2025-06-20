resource "aws_instance" "this" {
  for_each = var.instances

  ami = each.value.ami
  instance_type = each.value.instance_type
  key_name = each.value.key_name
  subnet_id = var.subnet_ids[each.value.subnet_key]
  vpc_security_group_ids = [
    each.value.public ? var.public_ec2_security_group_id : var.private_ec2_security_group_id
  ]

  tags = {
    Name = each.key
  }
}