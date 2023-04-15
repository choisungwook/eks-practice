resource "aws_iam_role" "eks-cluster" {
  name = "eks-cluster"

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

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster.name
}

# create iam user for login console. IAM user name is eks-administrator and has role aws_iam_role.eks-cluster
resource "aws_iam_user" "eks-administrator" {
  name = "eks-administrator"

  tags = {
    Name = "${var.eks-cluster-name}-eks-administrator"
  }
}
