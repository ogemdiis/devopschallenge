###### Creation of Network 
resource "aws_subnet" "public_subnet" {
  for_each =  var.public-subnet-cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.value[0]
  cidr_block        =  each.value[1]

  tags = {
    Name =  each.key
    Subnet = "public-subnet"
  }

  lifecycle {
    prevent_destroy = true
  }

}
variable "public-subnet-cidr" {
    type = map
    vpc = {
        "public-subnet-az1" = ["use1-az1", "10.10.10.0/26"]
        "public-subnet-az2" = ["use1-az4", "10.10.10.64/26"]
    }
  
}

resource "aws_subnet" "private_subnet" {
  for_each =  var.private-subnet-cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.value[0]
  cidr_block        =  each.value[1]

  tags = {
    Name =  each.key
    Subnet = "private-subnet"
  }

  lifecycle {
    prevent_destroy = true
  }

}
variable "private-subnet-cidr" {
    type = map
    vpc = {
        "private-subnet-az1" = ["use1-az1", "10.10.10.128/25"]
    }
  
}