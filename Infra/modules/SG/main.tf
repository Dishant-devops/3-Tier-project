resource "aws_security_group" "Eks_sg" {
 name = var.sg_name
 description = var.description
 vpc_id = var.vpc_id

 tags = var.tag

}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  for_each = var.ingress_rules

  security_group_id = aws_security_group.Eks_sg.id
  description         = each.value.description
  cidr_ipv4            = each.value.cidr_ipv4
  from_port            = each.value.from_port
  to_port              = each.value.to_port
  ip_protocol          = each.value.ip_protocol

}


resource "aws_vpc_security_group_egress_rule" "egress" {
  for_each = var.egress_rules

  security_group_id = aws_security_group.Eks_sg.id
  description         = each.value.description
  cidr_ipv4            = try(each.value.cidr_ipv4, "0.0.0.0/0")
  ip_protocol          = try(each.value.ip_protocol, "-1")

}