variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_cidr" {
  default = "10.0.1.0/24"
}

variable "public_az" {
  default = "us-east-1a"
}

variable "private_cidr" {
  default = "10.0.2.0/24"
}

variable "private_az" {
  default = "us-east-1b"
}

variable "key_pair" {
  default = "awscourse"
}

variable "instance_ami" {
  default = "ami-0e70db31f7e942241"
}

variable "nat_ami" {
  default = "ami-00a9d4a05375b2763"
}

variable "instance_type" {
  default = "t2.micro"
}
