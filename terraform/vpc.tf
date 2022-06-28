resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "vpc"
  }
}

# Create an internet gateway 
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "internet-gateway"
  }
}
# Create Elastic IP for NAT gateway
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "Nat-Gateway-IP"
  }
}

# Create an NAT gateway to give our private subnets to access to the outside world

resource "aws_nat_gateway" "default" {
  allocation_id = aws_eip.nat_eip.id
   subnet_id     = aws_subnet.private_subnet.id

}


# Create Route tables
resource "aws_route_table" "route" {
  for_each = toset( ["public-subnet-route-az1","public-subnet-route-az4"])
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags {
    Name = each.key
  }
}

resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.default.id
  }

  tags {
    Name = "private-route"
  }
}

resource "aws_route_table_association" "public" {
  for_each =  var.public-subnet-cidr
  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = each.value[0] == "use1-az1" ? aws_route_table.route["public-subnet-route-az1"].id : ( each.value[0] == "use1-az4" ? aws_route_table.route["public-subnet-route-az4"].id)
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private-route.id
}



