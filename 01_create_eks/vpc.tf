resource "aws_vpc" "eks_vpc" {
  cidr_block       = var.vpc-cidr
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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks-study-igw"
  }
}

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "eks-study-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["public_subnet_1"].id

  tags = {
    Name = "eks-study-nat-gateway"
  }
}

resource "aws_route_table" "public" {
  for_each = var.public_subnets

  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "eks-study-public-${each.key}"
  }
}

resource "aws_route_table" "private" {
  for_each = var.private_subnets

  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "eks-study-private-${each.key}"
  }
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}
