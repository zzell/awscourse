variable "cidr_vpc" {
  default = "10.1.0.0/24"
}

variable "cidr_subnet" {
  default = "10.1.0.0/24"
}

variable "key_pair" {
  default = "awscourse"
}

variable "asg_min" {
  default = 2
}

variable "asg_max" {
  default = 4
}

variable "db_class" {
  default = "db.t2.micro"
}

//variable "availability_zone" {
//  default = "us-east-1"
//}

//variable "public_key_path" {
//  default = "~/.ssh/id_rsa.pub"
//}

variable "instance_ami" {
  default = "ami-0e70db31f7e942241"
}

variable "instance_type" {
  default = "t2.micro"
}
