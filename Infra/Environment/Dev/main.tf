## VPC Module
module "vpc_module" {
  source     = "./modules/vpc"
  for_each   = var.vpc_config
  cidr_block = each.value.cidr_block

  tags = each.value.tags
}


## Subnet Module
module "subnet_module" {
  source            = "./modules/subnet"
  for_each          = var.subnet_config
  subnet_cidr_block = each.value.subnet_cidr_block
  vpc_id            = module.vpc_module["vpc1"].vpc_id
  subnet_tags       = each.value.subnet_tags
  availability_zone = each.value.availability_zone
}

## Internat Gateway
module "internet_gateway" {
  source                = "./modules/internet_gateway"
  for_each              = var.internat_gateway_config
  vpc_id                = module.vpc_module["vpc1"].vpc_id
  internet_gateway_tags = each.value.internet_gateway_tags
}

## Nat Gateway
module "Nat_Gateway" {
  source    = "./modules/nat_gateway"
  for_each  = var.Nat_gateway_Config
  subnet_id = module.subnet_module[each.value.subnet_name].subnet_id
  aws_nat_gateway_tags = {
    Name = "My-NAT"
  }
}


## Route Table
module "route_table_module" {
  source     = "./modules/Route_table"
  for_each   = var.Route_table_config
  vpc_id     = module.vpc_module["vpc1"].vpc_id
  gateway_id = each.value.private == 0 ? module.internet_gateway[each.value.gateway_name].internetGW_id : module.Nat_Gateway[each.value.gateway_name].natGW_id
  tags = {
    Name = each.value.private == 0 ? "Public-RT" : "Private-RT"
  }
}

## Route Table Subnet Association 
module "route_table_association" {
  source         = "./modules/Route_table_association"
  for_each       = var.route_table_association
  subnet_id      = module.subnet_module[each.value.subnet_name].subnet_id
  route_table_id = module.route_table_module[each.value.route_table_name].route_table_id
}


## Iam role for eks 
module "iam" {
  source       = "./modules/iam-eks"
  cluster_name = var.cluster_name
}

## EKS
module "eks_cluster" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
private_subnet_ids = [
    for key, subnet in module.subnet_module : subnet.subnet_id
    if can(regex("private", key))
  ]
  cluster_role_arn   = module.iam.cluster_role_arn
  node_role_arn      = module.iam.node_role_arn
  min_size           = var.min_size
  max_size           = var.max_size
  desired_size       = var.desired_size
  instance_types     = ["t3.medium"]
  depends_on         = [module.iam]
}
