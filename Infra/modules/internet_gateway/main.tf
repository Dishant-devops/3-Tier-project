resource "aws_internet_gateway" "my_igw"{
  vpc_id = var.vpc_id
  tags = var.internet_gateway_tags
}