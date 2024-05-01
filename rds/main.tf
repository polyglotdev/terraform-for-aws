provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "dom_vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dom-vpc"
  }
}

resource "random_pet" "db_name" {
  length    = 2
  separator = "-"
}

resource "aws_internet_gateway" "dom_igw" {
  vpc_id = aws_vpc.dom_vpc.id
}

resource "aws_route_table" "dom_rt" {
  vpc_id = aws_vpc.dom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dom_igw.id
  }
}

resource "aws_subnet" "db_subnet1" {
  vpc_id     = aws_vpc.dom_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "db_subnet2" {
  vpc_id     = aws_vpc.dom_vpc.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my_db_subnet_group"
  subnet_ids = [aws_subnet.db_subnet1.id, aws_subnet.db_subnet2.id]
}

resource "aws_db_instance" "default" {
  allocated_storage = 10
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"
  identifier        = "mydb"
  username          = "dbuser"
  password          = "dbpassword"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name

  backup_retention_period = 7                     # Number of days to retain automated backups
  backup_window           = "03:00-04:00"         # Preferred UTC backup window (hh24:mi-hh24:mi format)
  maintenance_window      = "mon:04:00-mon:04:30" # Preferred UTC maintenance window

  # Enable automated backups
  skip_final_snapshot = false
}

# Ensure dependencies are correctly managed
resource "aws_route_table_association" "rt_assoc1" {
  subnet_id      = aws_subnet.db_subnet1.id
  route_table_id = aws_route_table.dom_rt.id
}

resource "aws_route_table_association" "rt_assoc2" {
  subnet_id      = aws_subnet.db_subnet2.id
  route_table_id = aws_route_table.dom_rt.id
}
