# cluster간 노드 통신을 위한 security group
# cluster security group에 추가
# resource "aws_security_group_rule" "inbound_cluster" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   security_group_id =  aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
#   source_security_group_id = aws_security_group.worker-nodes.id
# }

resource "aws_security_group" "eks_cluster" {
  name = "${var.eks-cluster-name}-eks-cluster-sg"

  vpc_id      = aws_vpc.eks_vpc.id
  description = "eks cluster control-plane secruty group"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.eks-cluster-name}-eks-cluster-sg"
  }
}

resource "aws_security_group" "eks_nodes" {
  name        = "${var.eks-cluster-name}-eks-workernodes-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.eks_vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name                                            = "${var.eks-cluster-name}-eks-cluster-sg"
    "kubernetes.io/cluster/${var.eks-cluster-name}" = "owned"
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "nodes" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "nodes_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
  to_port                  = 65535
  type                     = "ingress"
}

# resource "aws_security_group_rule" "cluster_outbound" {
#   description              = "Allow cluster API Server to communicate with the worker nodes"
#   from_port                = 1024
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.eks_cluster.id
#   source_security_group_id = aws_security_group.eks_nodes.id
#   to_port                  = 65535
#   type                     = "egress"
# }


# resource "aws_security_group" "worker-nodes" {
#   name = "${var.eks-cluster-name}-eks-worker-nodes-sg"

#   vpc_id      = aws_vpc.eks_vpc.id
#   description = "eks cluster control-plane secruty group"

#   ingress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     # security_groups  = [aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id]
#     cidr_blocks = [var.vpc-cidr]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "eks-cluster-sg-${var.eks-cluster-name}"
#   }
# }

resource "aws_eks_cluster" "eks" {
  name    = var.eks-cluster-name
  version = var.eks-cluster-version

  role_arn = aws_iam_role.eks-cluster.arn

  vpc_config {
    subnet_ids              = [for key, value in aws_subnet.private : value.id]
    security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_nat_gateway.nat,
    aws_internet_gateway.igw,
    aws_route_table.public,
    aws_route_table.private,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
  ]
}

// Worker nodes


resource "aws_security_group" "endpoint_ec2" {
  name   = "${var.eks-cluster-name}-eks-cluster-endpoint"
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_security_group_rule" "endpoint_ec2_443" {
  security_group_id = aws_security_group.endpoint_ec2.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.vpc-cidr]
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id              = aws_vpc.eks_vpc.id
  service_name        = "com.amazonaws.ap-northeast-2.ec2"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [for key, value in aws_subnet.private : value.id]

  security_group_ids = [
    aws_security_group.endpoint_ec2.id,
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

  image_id      = var.eks-worker-nodes-ami-id
  instance_type = var.eks-worker-nodes-instance-type
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
    aws_vpc_endpoint.ec2,
    aws_iam_role_policy_attachment.worker-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.worker-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.worker-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
