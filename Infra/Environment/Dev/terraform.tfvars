vpc_config = {

  "vpc1" = {

    cidr_block = "10.0.0.0/16"

    tags = {

      Name = "EKS_VPC"

    }
  }
}


## Subnet

subnet_config = {

  "public_subnet_1" = {

    vpc_name = "EKS_VPC"

    subnet_cidr_block = "10.0.0.0/24"

    availability_zone = "us-east-1a"

    subnet_tags = {

      Name = "EKS_public_subnet_1_us-east-1a"

    }

  }

  "private_subnet_1" = {

    vpc_name = "EKS_VPC"

    subnet_cidr_block = "10.0.1.0/24"

    availability_zone = "us-east-1a"

    subnet_tags = {

      Name = "EKS_private_subnet_1_us-east-1a"

    }
  }

  "public_subnet_2" = {

    vpc_name = "EKS_VPC"

    subnet_cidr_block = "10.0.2.0/24"

    availability_zone = "us-east-1b"

    subnet_tags = {

      Name = "EKS_public_subnet_2_us-east-1b"

    }
  }

  "private_subnet_2" = {

    vpc_name = "EKS_VPC"

    subnet_cidr_block = "10.0.3.0/24"

    availability_zone = "us-east-1b"

    subnet_tags = {

      Name = "EKS_private_subnet_2_us-east-1b"

    }
  }


  "public_subnet_3" = {

    vpc_name = "EKS_VPC"

    subnet_cidr_block = "10.0.4.0/24"

    availability_zone = "us-east-1c"

    subnet_tags = {

      Name = "EKS_public_subnet_3_us-east-1c"

    }
  }


  "private_subnet_3" = {

    vpc_name = "EKS_VPC"

    subnet_cidr_block = "10.0.5.0/24"

    availability_zone = "us-east-1c"

    subnet_tags = {

      Name = "EKS_private_subnet_3_us-east-1c"

    }
  }


}

# Internatgateway

internat_gateway_config = {

  "Igw1" = {
    vpc_name = "vpc1"

    internet_gateway_tags = {
      Name = "my-igw"
    }
  }
}

# # NatGateway
Nat_gateway_Config = {
  nat1 = {
    subnet_name = "public_subnet_1"
    internet_gateway_tags = {
      Name = "NAT1"
    }
  }
}

# Route Table
Route_table_config = {
  publicrt1 = {
    private      = 0
    gateway_name = "Igw1"

    tags = {
      name = "publicrt1"
    }
  }
  privatert1 = {
    private      = 1
    gateway_name = "nat1"

    tags = {
      name = "privatert1"
    }
  }
}


## Route_table_subnet_associations

route_table_association = {
  pub1 = {
    subnet_name      = "public_subnet_1"
    route_table_name = "publicrt1"
  }
  pub2 = {
    subnet_name      = "public_subnet_2"
    route_table_name = "publicrt1"
  }
  pub3 = {
    subnet_name      = "public_subnet_3"
    route_table_name = "publicrt1"
  }

  pri1 = {
    subnet_name      = "private_subnet_1"
    route_table_name = "privatert1"
  }
  pri2 = {
    subnet_name      = "private_subnet_2"
    route_table_name = "privatert1"
  }
  pri3 = {
    subnet_name      = "private_subnet_3"
    route_table_name = "privatert1"
  }
}

cluster_name = "my-cluster"
min_size     = 1
max_size     = 3
desired_size = 2