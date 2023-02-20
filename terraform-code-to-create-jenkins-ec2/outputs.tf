output "ec2_public_ip" {
  value = aws_instance.delesapp-server.public_ip
}
