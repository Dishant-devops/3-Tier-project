resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn 

  vpc_config {
    # Placing the Cluster ENIs in private subnets is best practice
    subnet_ids = var.private_subnet_ids 
    
    # Optional: Enable public access to the API server so you can run kubectl from your laptop
    endpoint_public_access = true 
    endpoint_private_access = true
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.node_role_arn 
  
  # CRITICAL: Worker nodes must be in private subnets
  subnet_ids      = var.private_subnet_ids 

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = var.instance_types
  
  # Ensure the cluster is ready before creating nodes
  depends_on = [aws_eks_cluster.main]
}