resource "aws_vpc" "eks_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "eks-study"
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone


  tags = {
    Name = "eks-study-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = "eks-study-${each.key}"
  }
}
