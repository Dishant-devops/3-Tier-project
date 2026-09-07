terraform {
  backend "s3" {
    bucket = "vpc-terraform-state-file-bucket"
    key    = "eks-prod/terraform.tfstate"
    region = "us-east-1"
  
    encrypt = true
  }
}
