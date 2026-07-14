resource "aws_key_pair" "my_ec2_key" {
  key_name   = "day2-terra-auto-key"
  public_key = file("day2-terra-auto-key.pub")
}

data "aws_ami" "ubuntu" { #we used this method because we dont want to hardcode it and ami changes with region
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }


  owners = ["099720109477"] # Canonical owner
}

resource "aws_default_vpc" "default" { #this will use default VPC
}

resource "aws_security_group" "my_ec2_sg" {
  name        = "terra-auto-sg-day2-3"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id #interpolation 

}
#ingress rules
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

}
# Egress (outbound rule)

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.my_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "my_ec2_instance" {
  ami                    = data.aws_ami.ubuntu.id # for data you need to mention it 
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_ec2_sg.id]
  key_name               = aws_key_pair.my_ec2_key.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  tags = {
    Name = "terraweek"
  }
}
