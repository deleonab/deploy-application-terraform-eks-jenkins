Our aim here is to use a CI/CD pipeline to deploy a Kubernetes container running Nginx, using EKS ,Jenkins and Terraform

We shall create a Jenkins Server and run a jenkins pipeline to create the cluster, deployments and services.

1. Create a keypair jenkins-server

![jenkins keypair](./images/pem-image.png)


#### Next , we shall prepare tge terraform files to provision our infrastructure

#### Let us set up the backend to host our terraform state in the cloud
terraform {
  backend "s3" {
    bucket = "test-app"
    key    = "jenkins-server/terraform.tfstate"
    region = "us-east-1"
  }


