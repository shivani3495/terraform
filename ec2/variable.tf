variable "instance_region" {
    description = "default region"
    default = "ap-south-1"
  
}
# ubuntu mysql server for private subnet
variable "instance_id1" {
    description = "instance ami id"
    default = "ami-0a4a70bd98c6d6441"
  
}
#variable "instance_id_input" {
 #   description = "instance ami id use for server"
 #   type = string
  
#} 

# below is the linux ami apache server(public subnet) 
variable "instance_id2" {
    description = "instance ami id"
    default = "ami-04b1ddd35fd71475a"
  
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.1.0/24"
}