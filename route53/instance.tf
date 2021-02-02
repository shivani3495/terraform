#Create a virtual network
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "MY_VPC"
    }
}
#Create your application segment
resource "aws_subnet" "my_app-subnet" {
    tags = {
        Name = "APP_Subnet"
    }
    vpc_id = aws_vpc.my_vpc.id
    availability_zone = "ap-south-1a"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    depends_on= [aws_vpc.my_vpc]
}

#Define routing table
resource "aws_route_table" "my_route-table" {
    tags = {
        Name = "MY_Route_table"
       
    }
     vpc_id = aws_vpc.my_vpc.id
}

#Associate subnet with routing table
resource "aws_route_table_association" "App_Route_Association" {
  subnet_id      = aws_subnet.my_app-subnet.id 
  route_table_id = aws_route_table.my_route-table.id
}

#Create internet gateway for servers to be connected to internet
resource "aws_internet_gateway" "my_IG" {
    tags = {
        Name = "MY_IGW"  
    }
     vpc_id = aws_vpc.my_vpc.id
     depends_on = [aws_vpc.my_vpc]
}

#Add default route in routing table to point to Internet Gateway
resource "aws_route" "default_route" {
  route_table_id = aws_route_table.my_route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_IG.id
}

#Create a security group
resource "aws_security_group" "App_SG" {
    name = "App_SG"
    description = "Allow Web inbound traffic"
    vpc_id = aws_vpc.my_vpc.id
    ingress  {
        protocol = "tcp"
        from_port = 80
        to_port  = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress  {
        protocol = "tcp"
        from_port = 22
        to_port  = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress  {
        protocol = "-1"
        from_port = 0
        to_port  = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#Create a private key which can be used to login to the webserver
resource "tls_private_key" "Web-Key" {
  algorithm = "RSA"
}

#Save public key attributes from the generated key
resource "aws_key_pair" "App-Instance-Key" {
  key_name   = "Web-key"
  public_key = tls_private_key.Web-Key.public_key_openssh
}

#Save the key to your local system
resource "local_file" "Web-Key" {
    content     = tls_private_key.Web-Key.private_key_pem 
    filename = "Web-Key.pem"
}

#Create your webserver instance
resource "aws_instance" "IP_example" {
    ami = "ami-0a4a70bd98c6d6441"
    availability_zone = "ap-south-1a"
    instance_type = "t2.micro"
    tags = {
        Name = "WebServer1"
    }
    
    subnet_id = aws_subnet.my_app-subnet.id 
    key_name = "Web-key"
    security_groups = [aws_security_group.App_SG.id]

    user_data = <<EOF
        #!/bin/sh
        sudo apt-get update
        sudo apt-get install apache2

    EOF
}

resource "aws_eip" "eip" {
  instance = aws_instance.IP_example.id
  vpc      = true
}

output "public_ip" {
  value = aws_instance.IP_example.public_ip
}

resource "aws_route53_zone" "easy_aws" {
  name = "easyaws.in"

  tags = {
    Environment = "dev"
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.easy_aws.zone_id
  name    = "www.easyaws.in"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.eip.public_ip]
}

output "name_server"{
  value=aws_route53_zone.easy_aws.name_servers
}