resource "aws_key_pair" "key-pair" {
# Name of the key 
key_name = "tfkeypair"
# Adding the SSH authorized key
public_key = file("public.pub")
}

resource "aws_instance" "ec2_jenkins" {
  ami           = lookup(var.ami_id, var.region)
  instance_type = var.instance_type
  # Security group assign to instance
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # key name
  key_name = "tfkeypair"

  user_data = <<EOF
		#! /bin/bash
                sudo yum update -y
		sudo yum install -y httpd.x86_64
		sudo service httpd start
		sudo service httpd enable
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
        yum install java-1.11.0-openjdk-devel -y
        curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
        sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
        yum install -y jenkins
        systemctl start jenkins
        systemctl status jenkins
        systemctl enable jenkins
	   EOF

  tags = {
    Name = "Ec2-User-data"
  }
}