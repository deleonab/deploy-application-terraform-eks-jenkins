### S3 backend

terraform {
  backend "s3" {
    bucket = "deletus-app"
    key    = "jenkins-server/terraform.tfstate"
    region = "us-east-1"
  }
}