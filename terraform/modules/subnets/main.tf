resource "aws_subnet" "this" {
  for_each = var.subnets

  vpc_id = var.vpc_id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.aviability_zone
  map_public_ip_on_launch = each.value.public
}

resource "aws_route_table_association" "public_association" {
  for_each = {
    for key,value in var.subnets : key => value
    if value.public
  }

  subnet_id = aws_subnet.this[each.key].id
  route_table_id = var.route_table_id
}