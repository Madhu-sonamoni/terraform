# VPC
resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "Myvpc"
  }
}

# pub-Subnets
resource "aws_subnet" "pub_sns" {
  count = length (var.pub_subnet_cidr)
  vpc_id = aws_vpc.vpc1.id
  cidr_block = var.pub_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    "Name" = join("-", ["Myvpc","pub","subnet",count.index])
  }
}

#IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id
}

#RouteTable
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = join("-", ["Myvpc","pub","RouteTable"])
  }
}

#RouteTable Association
resource "aws_route_table_association" "pub_sns_ass" {
  count = length (var.pub_subnet_cidr)
  subnet_id = aws_subnet.pub_sns.*.id[count.index]
  route_table_id = aws_route_table.pub_rt.id
}