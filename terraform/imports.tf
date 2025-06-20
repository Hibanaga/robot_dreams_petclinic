import {
  to = aws_vpc.imported_vpc
  id = "vpc-003711a0594047037"
}

import {
  to = aws_subnet.imported_public_subnet_1
  id = "subnet-01cd35bd6eec74803"
}

import {
  to = aws_subnet.imported_private_subnet_1
  id = "subnet-04794883604aefb0e"
}

import {
  to = aws_route_table.imported_route_table
  id = "rtb-0faa1af67482faa70"
}

import {
  to = aws_internet_gateway.imported_internet_gateway
  id = "igw-0dac3f29edcfd93b5"
}

import {
  to = aws_instance.imported_public_server
  id = "i-06cc9a177d7014d60"
}

import {
  to = aws_instance.imported_private_server
  id = "i-0eed4fa5b9ac9b72b"
}

import {
  to = aws_security_group.public_ec2_security_group
  id = "sg-00d693700f1191ae6"
}

import {
  to = aws_security_group.private_ec2_security_group
  id = "sg-03021a7986b37261c"
}