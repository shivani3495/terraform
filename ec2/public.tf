/*
  Web Servers
*/
resource "aws_security_group" "web" {
    name = "vpc_web"
    description = "Allow incoming HTTP connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22

    # Here adding tcp instead of ssh, because ssh in part of tcp only!
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  

   egress {
    description = "output"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    vpc_id = aws_vpc.custom.id

    tags = {
        Name = "WebServerSG"
    }
}

resource "aws_instance" "public-1" {
    ami = var.instance_id2
    availability_zone = "ap-south-1a"
    instance_type = "t2.micro"
    key_name = "tfkeypair"
    vpc_security_group_ids = [aws_security_group.web.id]
    subnet_id = aws_subnet.ap-south-1a-public.id
    associate_public_ip_address = true
    #source_dest_check = false


    tags = {
        Name = "Apache Server"
    }
    user_data = <<EOF
        #!/bin/sh
        yum update
        yum install httpd -y
        service httpd start
    EOF

}

