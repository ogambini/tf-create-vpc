# Allocate Elastic IP Addresses
# terraform aws allocate elastic ip
resource "aws_eip" "eip-for-nat-gateway" {
  count = length(var.public_availability_zones)
  vpc   = true
  tags   = {
    Name = "EIP NAT Gateway ${count.index}"
  }
}

# Create Nat Gateway in Public Subnets
# terraform create aws nat gateway
resource "aws_nat_gateway" "nat-gateway" {
  count         = length(var.public_availability_zones)  
  allocation_id = aws_eip.eip-for-nat-gateway[count.index].id
  subnet_id     = aws_subnet.public-subnet[count.index].id
  tags          = {
    Name = "Nat Gateway Public Subnet ${var.public_availability_zones[count.index]} - ${var.public_subnets_cidr[count.index]}"
  }
}

# Create Private Route Tables and Add Route Through Nat Gateways
# terraform aws create route table
resource "aws_route_table" "private-route-table" {
  count   = length(var.public_availability_zones)
  vpc_id  = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway[count.index].id
  }
  tags   = {
    Name = "Private Route Table ${var.public_availability_zones[count.index]}"
  }
}

# Associate Private Subnets with associated Private Route Tables
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-route-table-association" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private-route-table[index(var.public_availability_zones, var.private_availability_zones[count.index])].id
}