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

resource "random_pet" "name" {
  length    = 2
  separator = "-"
}

# create a db server and output the public ip and private ip
resource "aws_instance" "ec2-dom" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  count         = 1
  subnet_id     = aws_subnet.subnet.id
  tags = {
    Name = random_pet.name.id
  }
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

# create a security group that allows ssh and http
resource "aws_security_group" "sg" {
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

  tags = {
    Name = random_pet.name.id
  }
}

output "public_ip" {
  value = aws_instance.ec2-dom.*.public_ip
}

output "private_ip" {
  value = aws_instance.ec2-dom.*.private_ip
}
