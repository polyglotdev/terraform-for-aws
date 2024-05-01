terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "ec2" {
  source = "./ec2/"
}

provider "aws" {
  region = "us-east-1"
}