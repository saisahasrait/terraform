# create a role to atatch to EKS
resource "aws_iam_role" "eks_worker_node_role" {
    name = "eks-node-group-role"

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
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
    #The ARN of the policy you want to apply. We can use Amazon managed policy 'AmazonEKSClusterPolicy'
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

    # The role the policy shuld be applied to
    role = aws_iam_role.eks_worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_policy" {
    #The ARN of the policy you want to apply. We can use Amazon managed policy 'AmazonEKSClusterPolicy'
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

    # The role the policy shuld be applied to
    role = aws_iam_role.eks_worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
    #The ARN of the policy you want to apply. We can use Amazon managed policy 'AmazonEKSClusterPolicy'
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

    # The role the policy shuld be applied to
    role = aws_iam_role.eks_worker_node_role.name
}

# Create worker node group

resource "aws_eks_node_group" "node_general"{
    # Name of the EKS cluster name
    cluster_name = aws_eks_cluster.eks.name

    # Name of the EKS node group
    node_group_name = "nodes-general"

    # Amazon Resourse Name (ARN) of the IAM role the provides permission for the EKS
    node_role_arn = aws_iam_role.eks_worker_node_role.arn

    # Identifiers of EC2 subnets to associate with the EKS node group.
    # These subnets must have the following resource tag:
    # kubernetes.io/cluster/CLUSTER_NAME (here replaced CLUSTER_NAME wit the name of the EKS cluster)
    subnet_ids = [ aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id ]

    # Configure block with scaling settings
    scaling_config {
        desired_size=2
        max_size=2
        min_size = 2
    }

    # Type of Amazon Machine Image (AMI) associated with the EKS Node group.
    # ami_type to be one of [AL2_x86_64 AL2_x86_64_GPU AL2_ARM_64 CUSTOM],
    ami_type = "AL2_x86_64"

    # Type of capacity associated with the EKS node group
    # Valid values: ON_DEMAND, SPOT
    capacity_type = "ON_DEMAND"

    # Disk size in GiB for worker nodes
    disk_size = 5

    # Force version update if existing pods are unable to be drained due to a pod disruption budget issue.
    force_update_version = false

    # List of Instance types associated with the EKS node
    instance_types=["t3.small"]

    labels = {
        role="nodes-general"
    }

    # Kubernetes version
    version = "1.19"

    # Ensure the IAM roles are created before and deleted after EKS node group is created
    # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic network
    depends_on = [
        aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
        aws_iam_role_policy_attachment.amazon_ec2_container_registry_policy,
        aws_iam_role_policy_attachment.amazon_eks_cni_policy
    ]




}