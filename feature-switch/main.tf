provider "aws" {
  region = "eu-west-2"
}

variable "environment" {
  type = string
}

variable "number_of_servers" {
  type        = number
  default     = 1
  description = "value of number of servers"
}

resource "aws_instance" "ec2" {
  ami           = "ami-032598fcc7e9d1c7a"
  instance_type = "t2.micro"
  count         = var.environment == "prod" ? 1 : 0
}