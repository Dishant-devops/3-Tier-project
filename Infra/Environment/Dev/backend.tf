terraform {
  backend "s3" {
    bucket       = "my-bucket-782989862342-us-east-1-an"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true # S3 native locking 
  }
}