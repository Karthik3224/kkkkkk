##########################################
# main.tf — FINAL (FIXED)
##########################################

############################
# Existing Security Group
############################
data "aws_security_group" "web_sg" {
  name = "web-sg"
}

############################
# Key Pair
############################
resource "aws_key_pair" "main_key" {
  key_name   = "main-static-key"
  public_key = file("${path.module}/../ansible/keys/id_rsa.pub")
}

############################
# EC2 Instance
############################
resource "aws_instance" "web_server" {
  ami           = "ami-00d8fc944fb171e29"   # Ubuntu 22.04 (ap-southeast-1)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.main_key.key_name

  vpc_security_group_ids = [
    data.aws_security_group.web_sg.id
  ]

  tags = {
    Name = "devops-web-server"
  }
}

############################
# Outputs
############################
output "public_ip" {
  value = aws_instance.web_server.public_ip
}

output "public_dns" {
  value = aws_instance.web_server.public_dns
}
