terraform {
  backend "s3" {
    bucket = "deletus-app"
    region = "us-east-1"
    key = "eks/terraform.tfstate"
  }
}