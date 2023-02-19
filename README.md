Our aim here is to use a CI/CD pipeline to deploy a Kubernetes container running Nginx, using EKS ,Jenkins and Terraform

We shall create a Jenkins Server and run a jenkins pipeline to create the cluster, deployments and services.

## 1. Let us set up the backend to host our terraform state in the cloud

### Create a keypair jenkins-server

![jenkins keypair](./images/pem-image.png)

#### We shall create S3 bucket called deletus-app in the console and then define it in our terraform code

![s3 bucket](./images/s3bucket1.png)

![s3 bucket](./images/s3bucket2.png)

#### Next , we shall prepare the terraform files to provision our infrastructure
Create backend.tf
```
touch backend.tf
```

```
terraform {
  backend "s3" {
    bucket = "deletus-app"
    key    = "jenkins-server/terraform.tfstate"
    region = "us-east-1"
  }
  }
```


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

## 2.  Prepare the Jenkins Server using terraform and a userdata script(EC2)
```
touch jenkins-server.tf
```
## 
```

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```
### provision ec2 with latest amzn2-ami-hvm-*-x86_64-gp2 image
```
resource "aws_instance" "myapp-server" {
  ami                         = data.aws_ami.latest-amazon-linux-image.id
  instance_type               = var.instance_type
  key_name                    = "jenkins-server"
  subnet_id                   = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids      = [aws_default_security_group.default-sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  user_data                   = file("jenkins-userdata.sh")
  tags = {
    Name = "${var.env_prefix}-server"
  }
}

```
### Create userdata script for jenkins instance
### This will install jenkins, git, java, terraform, and kubectl

```
#!/bin/bash

# install jenkins 

sudo yum update
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

# install git
sudo yum install git -y

# install terraform

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

# install kubectl

sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mkdir -p $HOME/bin && sudo cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin

```

### We will create outputs.tf to output the public ip address of our jenkins server

```
output "ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip
}
```