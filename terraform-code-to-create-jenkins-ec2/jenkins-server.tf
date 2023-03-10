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

resource "aws_instance" "delesapp-server" {
  ami                         = data.aws_ami.latest-amazon-linux-image.id
  instance_type               = var.instance_type
  key_name                    = "jenkins-server"
  subnet_id                   = aws_subnet.delesapp-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.delesapp-sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  user_data                   = file("jenkins-userdata.sh")
  tags = {
    Name = "${var.env_prefix}-server"
  }
}

resource "aws_eip" "ip-test-env" {

  instance = "${aws_instance.delesapp-server.id}"

  vpc      = true

}
