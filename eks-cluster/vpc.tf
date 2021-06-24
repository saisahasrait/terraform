resource "aws_vpc" "eks_vpc" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  # Required for EKS. Enable/disable DNS support in the VPC
  enable_dns_support = true
  # Required for EKS. Enable/disable DNS hostnames in the VPC
  enable_dns_hostnames = true

  #Enable/disable classiclink for the VPS
  enable_classiclink = false

  #Enable/disable ClassicLink DNS support for the VPC
  enable_classiclink_dns_support = false

  #Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length
  assign_generated_ipv6_cidr_block = false

  #A map of tags to assign to the resource
  tags = {
    Name = "eks-vpc"
  }
}

output "vpc_id" {
  description = "EKS VPC ID"
  value       = aws_vpc.eks_vpc.id

}