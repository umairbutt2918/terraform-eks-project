resource "aws_iam_role" "eks_cluster" {
 name = "eks-cluster-role"

 assume_role_policy = jsonencode({
  Version = "2012-10-17"
  Statement = [{
   Effect = "Allow"
   Principal = {
    Service = "eks.amazonaws.com"
   }
   Action = "sts:AssumeRole"
  }]
 })
}

resource "aws_eks_cluster" "cluster" {
 name = "terraform-eks"

 role_arn = aws_iam_role.eks_cluster.arn

 vpc_config {
  subnet_ids = var.subnet_ids
 }
}

resource "aws_eks_node_group" "nodes" {
 cluster_name = aws_eks_cluster.cluster.name
 node_group_name = "worker-nodes"

 node_role_arn = aws_iam_role.eks_cluster.arn

 subnet_ids = var.subnet_ids

 scaling_config {
  desired_size = 1
  max_size     = 1
  min_size     = 1
 }

 instance_types = ["t3.micro"]
}