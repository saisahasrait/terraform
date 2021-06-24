resource "aws_route_table" "eks_route_public" {
  vpc_id = aws_vpc.eks_vpc.id
  # routing from PUBLIC subnet to outside world via Internet gateway
  # destination, target
  # 0.0.0.0/0, igw
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
  tags = {
    Name = "public"
  }

}

resource "aws_route_table" "eks_route_private1" {
  vpc_id = aws_vpc.eks_vpc.id
  # routing from first PRIVATE subnet to outside world via NAT gateway
  # destination, target
  # 0.0.0.0/0, NAT gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.eks_nat_gw1.id
  }
  tags = {
    Name = "private1"
  }

}

resource "aws_route_table" "eks_route_private2" {
  vpc_id = aws_vpc.eks_vpc.id
  # prouting from second PRIVATE subnet to outside world via Internet gateway
  # destination, target
  # 0.0.0.0/0, igw
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.eks_nat_gw2.id
  }
  tags = {
    Name = "private2"
  }

}