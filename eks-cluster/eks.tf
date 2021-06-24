# create a role to atatch to EKS
resource "aws_iam_role" "eks_cluster_role" {
    name = "eks-cluster"

    # The policy that grants an entity permission to assume the role.
    #Used to access AWS resources that you might not normally have access to.
    # The role that Amazon EKS will use to create AWS resources for Kubernetes clusters.
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
    #The ARN of the policy you want to apply. We can use Amazon managed policy 'AmazonEKSClusterPolicy'
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

    # The role the policy shuld be applied to
    role = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "eks"{
    name="vmalla-eks"
    role_arn = aws_iam_role.eks_cluster_role.arn
    version="1.19"
    vpc_config {
      # Indicates whether or not the Amazon EKS private API server endpoint is enabled
      endpoint_private_access=false

      # Indicates whether or not the Amazon EKS public API server endpoint is enabled
      endpoint_public_access=true

      # Must be in at least two different availability zones. Make sure these subnets have a special tags for EKS
      subnet_ids=[
          aws_subnet.public_subnet1.id,
          aws_subnet.public_subnet2.id,
          aws_subnet.private_subnet1.id,
          aws_subnet.private_subnet2.id
      ]
    }

    # Ensure the IAM role permissions are created before and deleted after EKS Cluster
    #Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure
    depends_on = [
        aws_iam_role_policy_attachment.amazon_eks_cluster_policy
    ]

}

output "eks_cluster_endpoint" {
    description = "EKS cluster endpoint"
    value = aws_eks_cluster.eks.name
  
}