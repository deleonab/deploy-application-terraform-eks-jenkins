variable "avail_zone" {
  description = ""
  type = "string"
  default=""
}

variable "subnet_cidr_block " {
  description = "cidr block for the vpc"
  type = ""
  default="10.0.1.0/24"
}

variable "vpc_cidr_block " {
  description = "cidr block for the subnet"
  type = ""
  default="10.0.0.0/16"
}

variable " env_prefix" {
  description = "string"
  type = "dev"
  default=""
}

variable " instance_type" {
  description = "string"
  type = ""
  default="t2.micro"
}