resource "aws_instance" "elb_instance_example1" {
  ami           = lookup(var.ami_id, "ap-south-1")
  instance_type = var.instance_type
  subnet_id     = aws_subnet.ap-south-1a-public1.id
  associate_public_ip_address = true

  # Security group assign to instance
  vpc_security_group_ids = [aws_security_group.elb_sg.id]

  # key name
  key_name = var.key_name

  user_data = <<EOF
		#!/bin/bash
        sudo apt update -y
        sudo apt install mysql-server -y
        sudo mysql_secure_installation
        
	EOF

  tags = {
    Name = "EC2-Instance-1"
  }
}

resource "aws_instance" "elb_instance_example2" {
  ami           = lookup(var.ami_id, "ap-south-1")
  instance_type = var.instance_type
  subnet_id     = aws_subnet.ap-south-1b-public2.id
  associate_public_ip_address = true

  # Security group assign to instance
  vpc_security_group_ids = [aws_security_group.elb_sg.id]

  # key name
  key_name = var.key_name
  user_data = <<EOF
		#! /bin/bash
        sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
	EOF

  tags = {
    Name = "EC2-Instance-2"
  }
}



