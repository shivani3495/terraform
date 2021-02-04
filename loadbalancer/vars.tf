
variable "ami_id" {
  default = {
    ap-south-1    = "ami-0a4a70bd98c6d6441"
    ap-south-1    = "ami-0a4a70bd98c6d6441"
    
  }
}

variable "key_name" {
  
  default = "tfkeypair"
}

variable "instance_type" {
  type    = "string"
  default = "t2.micro"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr1" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "public_subnet_cidr2" {
    description = "CIDR for the Public Subnet"
    default = "10.0.1.0/28"
}

