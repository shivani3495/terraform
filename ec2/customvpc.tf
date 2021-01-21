resource "aws_vpc" "custom" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    tags = {
        Name = "terraform-aws-vpc"
    }
}

resource "aws_internet_gateway" "custom" {
    vpc_id = aws_vpc.custom.id
}

/*
  Public Subnet
*/
resource "aws_subnet" "ap-south-1a-public" {
    vpc_id = aws_vpc.custom.id

    cidr_block = var.public_subnet_cidr
    availability_zone = "ap-south-1a"

    tags = {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "ap-south-1a-public" {
    vpc_id = aws_vpc.custom.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.custom.id
    }

    tags = {
        Name = "Public Subnet"
    }
}


resource "aws_route_table_association" "ap-south-1a-public" {
    subnet_id = aws_subnet.ap-south-1a-public.id
    route_table_id = aws_route_table.ap-south-1a-public.id
}

resource "aws_eip" "Nat-Gateway-EIP" {
  depends_on = [
    aws_route_table_association.ap-south-1a-public
  ]
  vpc = true
}

/*
  Private Subnet
*/
resource "aws_subnet" "ap-south-1b-private" {
    vpc_id = aws_vpc.custom.id

    cidr_block = var.private_subnet_cidr
    availability_zone = "ap-south-1b"

    tags = {
        Name = "Private Subnet"
    }
}

#resource "aws_route_table" "ap-south-1b-private" {
 #   vpc_id = aws_vpc.custom.id

  #  route {
   #     cidr_block = "0.0.0.0/0"
    #    #instance_id = "${aws_instance.nat.id}"
    #}
#}


resource "aws_nat_gateway" "NAT_GATEWAY" {
  depends_on = [
    aws_eip.Nat-Gateway-EIP
  ]

  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.Nat-Gateway-EIP.id
  
  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.ap-south-1a-public.id
  tags = {
    Name = "Nat-Gateway_Project"
  }
}

resource "aws_route_table" "NAT-Gateway-RT" {
  depends_on = [
    aws_nat_gateway.NAT_GATEWAY
  ]

  vpc_id = aws_vpc.custom.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_GATEWAY.id
  }

  tags = {
    Name = "Route Table for NAT Gateway"
  }

}

resource "aws_route_table_association" "Nat-Gateway-RT-Association" {
  depends_on = [
    aws_route_table.NAT-Gateway-RT
  ]

#  Private Subnet ID for adding this route table to the DHCP server of Private subnet!
  subnet_id      = aws_subnet.ap-south-1b-private.id

# Route Table ID
  route_table_id = aws_route_table.NAT-Gateway-RT.id
}

#resource "aws_route_table_association" "ap-south-1b-private" {
    #subnet_id = aws_subnet.ap-south-1b-private.id
    #route_table_id = aws_route_table.ap-south-1b-private.id
#}