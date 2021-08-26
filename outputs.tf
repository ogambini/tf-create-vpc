output "vpc_id" {
    value = aws_vpc.vpc.id
    description = "VPC identifier"
}

output "public_subnets_id" {
    value = aws_subnet.public-subnet.*.id
}

