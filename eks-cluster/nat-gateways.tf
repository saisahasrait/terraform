resource "aws_nat_gateway" "eks_nat_gw1" {

  #allocate Elastic IP address
  allocation_id = aws_eip.eks_eip_nat1.id

  # subnet ID of the subnet in which to place the gateway
  subnet_id = aws_subnet.public_subnet1.id

  tags = {
    Name = "NAT GW1 in public subnet1 eu-west-2a"
  }

}

resource "aws_nat_gateway" "eks_nat_gw2" {
  allocation_id = aws_eip.eks_eip_nat2.id
  subnet_id     = aws_subnet.public_subnet2.id

  tags = {
    Name = "NAT GW1 in public subnet2 eu-west-2b"
  }

}