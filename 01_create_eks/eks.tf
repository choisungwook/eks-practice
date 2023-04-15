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
    description = "Allow egress ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster-sg-${var.eks-cluster-name}"
  }
}

# managed node<->control plane 통신을 위한 security group
resource "aws_security_group_rule" "terraform-eks-cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.terraform-eks-cluster.id
  to_port           = 443
  type              = "ingress"
}

# managed node group간 통신을 위한 security group
resource "aws_security_group_rule" "terraform-eks-cluster-ingress-workstation-https" {
  self              = true
  description       = "Allow inbound traffic from the managed node-groups"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.additional-securitygroup.id
  type              = "ingress"
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

resource "aws_launch_template" "eks-worder-nodes" {
  name_prefix = "${var.eks-cluster-name}-worker-nodes"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.eks-worker-nodes-disk-size
      volume_type = "gp3"
      # 비용을 줄이기 위해 삭제
      delete_on_termination = true
    }
  }

  image_id               = var.eks-worker-nodes-ami-id
  instance_type          = var.eks-worker-nodes-instance-type
  vpc_security_group_ids = [aws_security_group.additional-securitygroup.id]
}

resource "aws_eks_node_group" "eks-worker-nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.eks-cluster-name}-worker-nodes"
  node_role_arn   = aws_iam_role.worker_node.arn
  subnet_ids      = [for key, value in aws_subnet.private : value.id]

  scaling_config {
    desired_size = var.eks-worker-nodes-desired-size
    max_size     = var.eks-worker-nodes-max-size
    min_size     = var.eks-worker-nodes-min-size
  }

  # EC2 Instance launch template
  launch_template {
    id      = aws_launch_template.eks-worder-nodes.id
    version = "$Latest"
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.worker-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.worker-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
