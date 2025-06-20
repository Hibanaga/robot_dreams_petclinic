resource "aws_instance" "this" {
  for_each = var.instances

  ami = each.value.ami
  instance_type = each.value.instance_type
  subnet_id = var.subnet_ids[each.value.subnet_key]

  tags = {
    Name = each.key
  }
}