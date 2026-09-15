resource "aws_network_acl" "Nacl" {
  vpc_id = var.vpc_id.id

  egress {
    protocol   = var.egress_protocol
    rule_no    = var.egress_rule_no
    action     = var.egress_action
    cidr_block = var.egress_cidr_block
    from_port  = var.egress_from_port
    to_port    = var.egress_to_port
  }

  ingress {
    protocol   = var.ingress_protocol
    rule_no    = var.ingress_rule_no
    action     = var.ingress_action
    cidr_block = var.ingress_cidr_block
    from_port  = var.ingress_from_port
    to_port    = var.ingress_to_port
  }

  tags = {
    Name = var.tags
  }
}