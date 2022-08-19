#Simple example provisionning an EC2 instance and installing
#
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region_name
}
data "aws_ssm_parameter" "webserver-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
data "aws_vpc" "default_vpc"{
  default = true
}
data "aws_key_pair" "my-key" {
  key_name           = var.key_name
  include_public_key = true

}
#Create SG for allowing TCP/80 & TCP/22
resource "aws_security_group" "my_app_server_sg" {
  name        = "sg"
  description = "Allow TCP/80 & TCP/22"
  vpc_id      = data.aws_vpc.default_vpc.id
  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow traffic from TCP/80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "app_server" {
  ami           = data.aws_ssm_parameter.webserver-ami.value
  instance_type = "t2.micro"
  key_name      = data.aws_key_pair.my-key.key_name
  security_groups = ["${aws_security_group.my_app_server_sg.name}"]
  associate_public_ip_address = true
  tags = {
    Name = "ExampleAppServerInstance"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<h1><center>Hello World!</center></h1>' > index.html",
      "sudo mv index.html /var/www/html/"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
  #"remote-exec" provisionner is not recommended in this case as it's stateless and 
  #could be replaced in this case by a EC2 user data script as follow ;
  #user_data = "${file("./user-data.sh")}"
  depends_on = [aws_security_group.my_app_server_sg]
}
