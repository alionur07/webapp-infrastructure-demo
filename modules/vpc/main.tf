data "aws_availability_zones" "available_zones" {}

# create vpc
resource "aws_vpc" "aoa_demo_vpc" {
  cidr_block              = var.vpc_cidr
  instance_tenancy        = "default"
  enable_dns_hostnames    = true
  enable_dns_support   = true

  tags      = {
    Name    = "${var.project_name}-vpc"
  }
}

# create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.aoa_demo_vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  tags      = {
    Name    = "public_subnet_az1"
  }
}

# create public subnet az2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  =  aws_vpc.aoa_demo_vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]

  tags      = {
    Name    = "public_subnet_az2"
  }
}


# create private app subnet az1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                   = aws_vpc.aoa_demo_vpc.id
  cidr_block               = var.private_subnet_az1_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private app subnet az1"
  }
}

# create private app subnet az2
resource "aws_subnet" "private_subnet_az2" {
  vpc_id                   = aws_vpc.aoa_demo_vpc.id
  cidr_block               = var.private_subnet_az2_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private app subnet az2"
  }
}

# internet Gateway for the public subnet
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.aoa_demo_vpc.id

  tags      = {
    Name    = "${var.project_name}-igw"
  }
}

# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet az1 
resource "aws_eip" "nat_gateway" {
  domain = "vpc"
  associate_with_private_ip = "10.0.0.5"

  tags   = {
    Name = "ngw-az1"
  }
}

# create nat gateway in public subnet az1
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags   = {
    Name = "ngw-az1"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [aws_internet_gateway.internet_gateway]
}


# Route tables for the subnets
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.aoa_demo_vpc.id
  tags = {
    Name = "public-route-table"
  }
}
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.aoa_demo_vpc.id
  tags = {
    Name = "private-route-table"
  }
}

# Route the public subnet traffic through the Internet Gateway
resource "aws_route" "public-internet-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

# Route NAT Gateway
resource "aws_route" "nat-ngw-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_az1.id
  destination_cidr_block = "0.0.0.0/0"
}

# Associate the route tables to the public az1 subnets
resource "aws_route_table_association" "public-route-az1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public_subnet_az1.id
}

# Associate the route tables to the public az2 subnets
resource "aws_route_table_association" "public-route-az2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public_subnet_az2.id
}

# Associate the route tables to the private az1 subnets
resource "aws_route_table_association" "private-route-az1-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private_subnet_az1.id
}

# Associate the route tables to the private az1 subnets
resource "aws_route_table_association" "private-route-az2-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private_subnet_az2.id
}