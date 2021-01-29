
variable "ami_id" {
  default = {
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

variable "subnets" {
  type    = list(string)
  default = ["subnet-fbb5ceb7","subnet-c4bab0ac","subnet-ff901d84"]
}


variable "security_group_id" {
  type    = "string"
  default = "sg-01a516a845286636f"
}