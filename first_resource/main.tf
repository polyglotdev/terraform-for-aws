terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"] # This is Canonical's AWS account ID for their official AMIs
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    "Name" = "vpc_dom"
  }
}

# create a ec2 instance
resource "aws_instance" "ec2_dom" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id

  tags = {
    "Name" = "ec2_dom"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    "Name" = "subnet_dom"
  }
}

output "name" {
  value = aws_instance.ec2_dom.tags["Name"]
}