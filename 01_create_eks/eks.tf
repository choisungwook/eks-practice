resource "aws_security_group" "additional-securitygroup" {
  name = "eks-cluster"

  vpc_id      = aws_vpc.eks_vpc.id
  description = "eks cluster control-plane secruty group"

  ingress {
    description = "Allow inbound traffic from the internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow inbound traffic from the internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster-sg-${var.eks-cluster-name}"
  }
}


resource "aws_eks_cluster" "eks" {
  name    = var.eks-cluster-name
  version = var.eks-cluster-version

  role_arn = aws_iam_role.eks-cluster.arn

  vpc_config {
    security_group_ids      = [aws_security_group.additional-securitygroup.id]
    subnet_ids              = [for key, value in aws_subnet.private : value.id]
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
  ]
}
