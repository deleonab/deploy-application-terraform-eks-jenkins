resource "aws_vpc" "delesapp-vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = var.dns_hostnames
  enable_dns_support = var.dns_support
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "delesapp-subnet-1" {
  vpc_id            = aws_vpc.delesapp-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "delesapp-igw" {
  vpc_id = aws_vpc.delesapp-vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}



resource "aws_route_table" "delesapp-rtb" {
  vpc_id = aws_vpc.delesapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.delesapp-igw.id
  }

  tags = {
    Name = "${var.env_prefix}-delesapp-rtb"
  }
}

resource "aws_route_table_association" "subnet-association" {

  subnet_id      = "${aws_subnet.delesapp-subnet-1.id}"

  route_table_id = "${aws_route_table.delesapp-rtb.id}"

}


resource "aws_security_group" "delesapp-sg" {
  vpc_id = aws_vpc.delesapp-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_prefix}-delesapp-sg"
  }
}