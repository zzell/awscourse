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
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet_pub" {
  cidr_block              = var.cidr_subnet
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
}

resource "aws_route_table" "rtb_pub" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta_subnet_pub" {
  route_table_id = aws_route_table.rtb_pub.id
  subnet_id      = aws_subnet.subnet_pub.id
}

resource "aws_security_group" "ec2_sg" {
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

resource "aws_dynamodb_table" "dynamodb" {
  hash_key       = "LookupKey"
  name           = "course-trainers-dynamo-db"
  write_capacity = 10
  read_capacity  = 10

  attribute {
    name = "LookupKey"
    type = "N"
  }
}

resource "aws_db_instance" "postgres" {
  instance_class      = var.db_class
  engine              = "postgres"
  allocated_storage   = 10
  username            = "postgres"
  password            = "ultra_mega_turbo_secret_string"
  skip_final_snapshot = true
}

resource "aws_instance" "runner" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.storage_manage_instance_profile.name
  subnet_id              = aws_subnet.subnet_pub.id
  // aws s3 cp s3://awscourse-04-2021/dynamodb-script.sh /tmp/dynamodb-script.sh && aws s3 cp s3://awscourse-04-2021/rds-script.sql /tmp/rds-script.sql
  user_data_base64 = "YXdzIHMzIGNwIHMzOi8vYXdzY291cnNlLTA0LTIwMjEvZHluYW1vZGItc2NyaXB0LnNoIC90bXAvZHluYW1vZGItc2NyaXB0LnNoICYmIGF3cyBzMyBjcCBzMzovL2F3c2NvdXJzZS0wNC0yMDIxL3Jkcy1zY3JpcHQuc3FsIC90bXAvcmRzLXNjcmlwdC5zcWw="
}

resource "aws_iam_instance_profile" "storage_manage_instance_profile" {
  role = aws_iam_role.storage_manage_role.name
  path = "/"
}

resource "aws_iam_role" "storage_manage_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Principal : {
          Service : "ec2.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "storage_manage_policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["dynamodb:*"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["rds-db:*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "server_policy" {
  role       = aws_iam_role.storage_manage_role.name
  policy_arn = aws_iam_policy.storage_manage_policy.arn
}
