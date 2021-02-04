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
resource "aws_subnet" "ap-south-1a-public1" {
    vpc_id = aws_vpc.custom.id

    cidr_block = var.public_subnet_cidr1
    availability_zone = "ap-south-1a"

    tags = {
        Name = "Public Subnet1"
    }
}

resource "aws_route_table" "ap-south-1a-public1" {
    vpc_id = aws_vpc.custom.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.custom.id
    }

    tags = {
        Name = "Public Subnet1"
    }
}


resource "aws_route_table_association" "ap-south-1a-public1" {
    subnet_id = aws_subnet.ap-south-1a-public1.id
    route_table_id = aws_route_table.ap-south-1a-public1.id
}



/*
  Public Subnet
*/
resource "aws_subnet" "ap-south-1b-public2" {
    vpc_id = aws_vpc.custom.id

    cidr_block = var.public_subnet_cidr2
    availability_zone = "ap-south-1b"

    tags = {
        Name = "Public Subnet2"
    }
}

resource "aws_route_table" "ap-south-1b-public2" {
    vpc_id = aws_vpc.custom.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.custom.id
    }

    tags = {
        Name = "Public Subnet2"
    }
}


resource "aws_route_table_association" "ap-south-1b-public2" {
    subnet_id = aws_subnet.ap-south-1b-public2.id
    route_table_id = aws_route_table.ap-south-1b-public2.id
}



