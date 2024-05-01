provider "aws" {
  region = "us-east-1"
}

resource "random_pet" "db_name" {
  length    = 2
  separator = "-"
}

resource "aws_vpc" "dom_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dom-vpc"
  }
}

resource "aws_internet_gateway" "dom_igw" {
  vpc_id = aws_vpc.dom_vpc.id
  tags = {
    Name = "dom-igw"
  }
}

resource "aws_route_table" "dom_rt" {
  vpc_id = aws_vpc.dom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dom_igw.id
  }
  tags = {
    Name = "dom-rt"
  }
}

resource "aws_subnet" "db_subnet1" {
  vpc_id            = aws_vpc.dom_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "db_subnet2" {
  vpc_id            = aws_vpc.dom_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_route_table_association" "rt_assoc1" {
  subnet_id      = aws_subnet.db_subnet1.id
  route_table_id = aws_route_table.dom_rt.id
}

resource "aws_route_table_association" "rt_assoc2" {
  subnet_id      = aws_subnet.db_subnet2.id
  route_table_id = aws_route_table.dom_rt.id
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my_db_subnet_group"
  subnet_ids = [aws_subnet.db_subnet1.id, aws_subnet.db_subnet2.id]
  tags = {
    Name = "My DB Subnet Group"
  }
}

resource "aws_db_instance" "default" {
  db_name              = random_pet.db_name.id
  allocated_storage    = 20
  engine               = "mariadb"
  identifier           = "my-first-db"
  instance_class       = "db.t2.micro"
  username             = "foo"
  password             = "bar"
  publicly_accessible  = true
  skip_final_snapshot  = true
  port                 = 3306
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
}
