# 01_create_eks

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.20.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 1.4 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.62.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.eks-worker-nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_role.eks-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.worker_node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker-node-AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker-node-AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker-node-AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.eks-administrator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_launch_template.eks-worder-nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.additional-securitygroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.terraform-eks-cluster-ingress-workstation-https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.eks_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks-cluster-name"></a> [eks-cluster-name](#input\_eks-cluster-name) | EKS cluster name | `string` | `"eks-cluster"` | no |
| <a name="input_eks-cluster-version"></a> [eks-cluster-version](#input\_eks-cluster-version) | EKS cluster version | `string` | `"1.24"` | no |
| <a name="input_eks-worker-nodes-ami-id"></a> [eks-worker-nodes-ami-id](#input\_eks-worker-nodes-ami-id) | EKS worker nodes ami | `string` | `"ami-0077d69c7df3f4949"` | no |
| <a name="input_eks-worker-nodes-desired-size"></a> [eks-worker-nodes-desired-size](#input\_eks-worker-nodes-desired-size) | EKS worker nodes desired size | `number` | `3` | no |
| <a name="input_eks-worker-nodes-disk-size"></a> [eks-worker-nodes-disk-size](#input\_eks-worker-nodes-disk-size) | EKS worker nodes disk size | `string` | `"20"` | no |
| <a name="input_eks-worker-nodes-instance-type"></a> [eks-worker-nodes-instance-type](#input\_eks-worker-nodes-instance-type) | EKS worker nodes max size | `string` | `"t2.medium"` | no |
| <a name="input_eks-worker-nodes-max-size"></a> [eks-worker-nodes-max-size](#input\_eks-worker-nodes-max-size) | EKS worker nodes max size | `number` | `3` | no |
| <a name="input_eks-worker-nodes-min-size"></a> [eks-worker-nodes-min-size](#input\_eks-worker-nodes-min-size) | EKS worker nodes min size | `number` | `2` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | private subent | <pre>map(object({<br>    cidr_block        = string<br>    availability_zone = string<br>  }))</pre> | <pre>{<br>  "private_subnet_1": {<br>    "availability_zone": "ap-northeast-2a",<br>    "cidr_block": "10.0.3.0/24"<br>  },<br>  "private_subnet_2": {<br>    "availability_zone": "ap-northeast-2c",<br>    "cidr_block": "10.0.4.0/24"<br>  }<br>}</pre> | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | public subent | <pre>map(object({<br>    cidr_block        = string<br>    availability_zone = string<br>  }))</pre> | <pre>{<br>  "public_subnet_1": {<br>    "availability_zone": "ap-northeast-2a",<br>    "cidr_block": "10.0.1.0/24"<br>  },<br>  "public_subnet_2": {<br>    "availability_zone": "ap-northeast-2c",<br>    "cidr_block": "10.0.2.0/24"<br>  }<br>}</pre> | no |
| <a name="input_vpc-cidr"></a> [vpc-cidr](#input\_vpc-cidr) | vpc cidr | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
