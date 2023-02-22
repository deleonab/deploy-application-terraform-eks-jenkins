variable "avail_zone" {
  description = "availability zone"
  type = string
  default=""
}

variable "subnet_cidr_block" {
  description = "cidr block for the vpc"
  default ="10.0.1.0/24"
}

variable "vpc_cidr_block" {
  description = "cidr block for the subnet"
  default ="10.0.0.0/16"
}

variable "env_prefix" {
  description = "prefix to append to other variables"
  type = string
  default="prod"
}

variable "instance_type" {
  description = "instance type for our jenkins server"
  type = string
  default="t2.micro"
}

variable "region" {
  type = string
}

variable "dns_hostnames" {
default = true
}

variable "dns_support" {
  default = true
}

