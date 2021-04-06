terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  cidr_block              = var.public_cidr
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  cidr_block              = var.private_cidr
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "nat_rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = aws_instance.public_nat.id
  }
}

resource "aws_route_table_association" "rta_subnet_pub" {
  route_table_id = aws_route_table.public_rtb.id
  subnet_id      = aws_subnet.public_subnet.id
}

resource "aws_route_table_association" "rta_subnet_priv" {
  route_table_id = aws_route_table.nat_rtb.id
  subnet_id      = aws_subnet.private_subnet.id
}

resource "aws_instance" "public_runner" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.public_ec2_sg.id]
  subnet_id              = aws_subnet.public_subnet.id
}

resource "aws_instance" "private_runner" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id]
  subnet_id              = aws_subnet.private_subnet.id
}

resource "aws_instance" "public_nat" {
  tags = { Name: "nat-ec2" }
  ami = var.nat_ami
  instance_type = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.public_ec2_sg.id]
  subnet_id              = aws_subnet.public_subnet.id
  source_dest_check = false
}

module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"

  name = "elb"

  subnets         = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
  security_groups = [aws_security_group.public_ec2_sg.id]
  internal        = false

  listener = [
    {
      instance_port     = 80
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    },
  ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  // ELB attachments
  number_of_instances = 2
  instances           = [aws_instance.public_runner.id, aws_instance.private_runner.id]
}

resource "aws_security_group" "public_ec2_sg" {
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_ec2_sg" {
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [var.public_cidr]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.public_cidr]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
