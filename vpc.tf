# Create VPC
# terraform aws create vpc
resource "aws_vpc" "vpc" {
  cidr_block            = "${var.vpc-cidr}"
  instance_tenancy      = "default"
  enable_dns_hostnames  = true
  tags                  = {
    Name = "${var.env_name} VPC"
  }
}

# Create Internet Gateway and Attach it to VPC
# terraform aws create internet gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id
  tags   = {
    Name = "Internet Gateway"
  }
}

# Create Public Subnets
# terraform aws create subnet
resource "aws_subnet" "public-subnet" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets_cidr[count.index]
  availability_zone       = var.public_availability_zones[count.index]
  map_public_ip_on_launch = true
  tags                    = {
    Name    = "Public Subnet ${var.public_availability_zones[count.index]} - ${var.public_subnets_cidr[count.index]}"
  }
}

# Create Private Subnets
# terraform aws create subnet
resource "aws_subnet" "private-subnet" {
  count                   = length(var.private_subnets_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnets_cidr[count.index]
  availability_zone       = var.private_availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name    = "Private Subnet ${var.private_availability_zones[count.index]} - ${var.private_subnets_cidr[count.index]}"
  }
}

# Create Route Table and Add Public Route
# terraform aws create route table
resource "aws_route_table" "public-route-table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags       = {
    Name     = "Public Route Table"
  }
}

# Associate Public Subnets to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnets-route-table-association" {
  count               = length(var.public_subnets_cidr)
  subnet_id           = aws_subnet.public-subnet[count.index].id
  route_table_id      = aws_route_table.public-route-table.id
}