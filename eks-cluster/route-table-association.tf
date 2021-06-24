resource "aws_route_table_association" "public1" {
  # The subnet ID to create an association
  subnet_id = aws_subnet.public_subnet1.id

  #The ID of the routing table to associate with
  route_table_id = aws_route_table.eks_route_public.id
}

resource "aws_route_table_association" "public2" {
  # The subnet ID to create an association
  subnet_id = aws_subnet.public_subnet2.id

  #The ID of the routing table to associate with
  route_table_id = aws_route_table.eks_route_public.id
}

resource "aws_route_table_association" "private1" {
  # The subnet ID to create an association
  subnet_id = aws_subnet.private_subnet1.id

  #The ID of the routing table to associate with
  route_table_id = aws_route_table.eks_route_private1.id
}

resource "aws_route_table_association" "private2" {
  # The subnet ID to create an association
  subnet_id = aws_subnet.private_subnet2.id

  #The ID of the routing table to associate with
  route_table_id = aws_route_table.eks_route_private2.id
}