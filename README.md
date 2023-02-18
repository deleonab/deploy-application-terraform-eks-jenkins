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



#### Don't forget to include a .gitignore file to avoid pushing our sensitive files to our git repository

```
# Local .terraform directories
**/.terraform/*

# .tfstate files
*.tfstate
*.tfstate.*

# Crash log files
crash.log
crash.*.log

# Exclude all .tfvars files, which are likely to contain sensitive data, such as
# password, private keys, and other secrets. These should not be part of version 
# control as they are data points which are potentially sensitive and subject 
# to change depending on the environment.
*.tfvars
*.tfvars.json

# Ignore override files as they are usually used to override resources locally and so
# are not checked in
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Include override files you do wish to add to version control using negated pattern
# !example_override.tf

# Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan
# example: *tfplan*

# Ignore CLI configuration files
.terraformrc
terraform.rc
```
