
#Create public subnets
resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "192.168.0.0/18"
  availability_zone = "eu-west-2a"

  #Required for EKS. Instances launched into thie subnet should be assgined
  #the public ip address
  map_public_ip_on_launch = true

  #very important tags for EKS. 
  tags = {
    Name = "public-subnet-eu-west-2a"
    #mandatory tags for EKS
    # kuberneres.io/cluster/[CLUSTER_NAME] -> here replace CLUSTER_NAME with the name of the EKS cluster
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1

  }
}
resource "aws_subnet" "public_subnet2" {
  vpc_id = aws_vpc.eks_vpc.id

  #previous cidr block ends with 192.168.63.255
  cidr_block        = "192.168.64.0/18"
  availability_zone = "eu-west-2b"

  #Required for EKS. Instances launched into thie subnet should be assgined
  #the public ip address
  map_public_ip_on_launch = true

  #very important tags for EKS. 
  tags = {
    Name = "public-subnet-eu-west-2b"
    #mandatory tags for EKS
    # kuberneres.io/cluster/[CLUSTER_NAME] -> here replace CLUSTER_NAME with the name of the EKS cluster
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1

  }
}

#Create private subnets
resource "aws_subnet" "private_subnet1" {
  vpc_id = aws_vpc.eks_vpc.id

  #previous cidr block ends with 192.168.127.255
  cidr_block        = "192.168.128.0/18"
  availability_zone = "eu-west-2a"

  #very important tags for EKS. 
  tags = {
    Name = "private-subnet-eu-west-2a"
    #mandatory tags for EKS
    "kubernetes.io/cluster/eks"       = "shared"
    "kubernetes.io/role/internal-elb" = 1

  }
}
resource "aws_subnet" "private_subnet2" {
  vpc_id = aws_vpc.eks_vpc.id

  #previous cidr block ends with 192.168.191.255
  cidr_block        = "192.168.192.0/18"
  availability_zone = "eu-west-2b"

  #very important tags for EKS. 
  tags = {
    Name = "private-subnet-eu-west-2b"
    #mandatory tags for EKS
    "kubernetes.io/cluster/eks"       = "shared"
    "kubernetes.io/role/internal-elb" = 1

  }
}