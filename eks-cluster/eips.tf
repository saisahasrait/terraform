# NAT gateway requires Elastic IP. Create an Elastic IP for first NAT gateway
# so that nodes in private subnet1 can talk to outside world via this NAT gateway
resource "aws_eip" "eks_eip_nat1" {
  # this resource allocates public static IP address in AWS

  #EIP may require IGW to exist prior to association.
  #Use depends_on to set an explicit dependency on the IGW
  depends_on = [aws_internet_gateway.eks_igw]
}

# NAT gateway requires Elastic IP. Create an Elastic IP for second NAT gateway
# so that nodes in private subnet2 can talk to outside world via this NAT gateway
resource "aws_eip" "eks_eip_nat2" {
  # this resource allocates public static IP address in AWS

  #EIP may require IGW to exist prior to association.
  #Use depends_on to set an explicit dependency on the IGW
  depends_on = [aws_internet_gateway.eks_igw]
}