resource "aws_security_group" "monitoring_security_group" {
  name = "monitoring-security-group"

  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = local.monitoring_ingress_rules
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidrs
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.all_ips
  }
}

resource "aws_security_group" "web_security_group" {
  name   = "web-security-group"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = local.web_ingress_rules
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidrs
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.all_ips
  }
}

resource "aws_security_group" "rds_security_group" {
  name   = "rds-security-group"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = local.rds_ingress_rules
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidrs
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.all_ips
  }

  tags = {
    Name = "rds-security-group"
  }
}