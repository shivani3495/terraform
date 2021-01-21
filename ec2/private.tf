resource "aws_security_group" "db" {
    name = "vpc_db"
    description = "Allow incoming database connections."

    ingress { # MySQL
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        #cidr_blocks = ["0.0.0.0/0"]
        security_groups = ["${aws_security_group.web.id}"]
    }


    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }
   
    
    egress {
    description = "output"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    vpc_id = "${aws_vpc.custom.id}"

    tags = {
        Name = "DBServerSG"
    }
}

resource "aws_instance" "db-1" {
    ami = var.instance_id1
    availability_zone = "ap-south-1b"
    instance_type = "t2.micro"
    key_name = "tfkeypair"
    vpc_security_group_ids = ["${aws_security_group.db.id}"]
    subnet_id = "${aws_subnet.ap-south-1b-private.id}"
    #source_dest_check = false

    tags = {
        Name = "mysql server"
    }
    
    user_data = <<-EOF
        #!/bin/bash
         apt update -y
         apt install -y mysql56-server
         service mysqld start

    EOF
}