#VPC
resource "aws_vpc" "vpc_terraform" {
  cidr_block       = "${var.cidr_block}"
  instance_tenancy = "default"

  tags = {
    Name = "vpc_terraform"
  }
}


#internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_terraform.id

  tags = {
    Name = "gw"
  }
}


resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc_terraform.id
  cidr_block = "${var.subnet1_cidr}"
  availability_zone = "${var.availability_zone_for_subnet1}"

  tags = {
    Name = "subnet1"
  }
}


resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.vpc_terraform.id
  cidr_block = "${var.subnet2_cidr}"
availability_zone = "${var.availability_zone_for_subnet2}"
  tags = {
    Name = "subnet2"
  }
}

/* ----------- route table--------------- */
resource "aws_route_table" "terra_rt" {
  vpc_id = aws_vpc.vpc_terraform.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "terra_rt"
  }
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.terra_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.terra_rt.id
}





resource "aws_security_group" "terraform_vpc_SG" {
  name        = "terraform_vpc_SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc_terraform.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpc_terraform.cidr_block]
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpc_terraform.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "terraform_vpc_SG"
  }
}








