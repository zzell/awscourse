variable "cidr_vpc" {
  default = "10.1.0.0/24"
}

variable "cidr_subnet" {
  default = "10.1.0.0/24"
}

variable "key_pair" {
  default = "awscourse"
}

variable "instance_ami" {
  default = "ami-0e70db31f7e942241"
}

variable "instance_type" {
  default = "t2.micro"
}
