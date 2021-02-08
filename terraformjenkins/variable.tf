variable "region" {
  default = "ap-south-1"
}
variable "ami_id" {
  
  default = {
    ap-south-1   = "ami-04b1ddd35fd71475a"
  }
}
variable "instance_type" {
  type    = "string"
  default = "t2.micro"
}
