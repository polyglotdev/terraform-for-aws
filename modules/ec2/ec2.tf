provider "aws" {
  region = "us-east-1"
}

variable "ec2_name" {
  type        = string
  description = "value for the ec2 instance name"
}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"] # This is Canonical's AWS account ID for their official AMIs
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "random_pet" "name" {
  length    = 2
  separator = "-"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = random_pet.name.id
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = random_pet.name.id
  }
}

resource "aws_instance" "ec2-dom" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  count         = 1
  subnet_id     = aws_subnet.subnet.id
  tags = {
    Name = random_pet.name.id
  }
}