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
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.eks_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | private subent | <pre>map(object({<br>    cidr_block        = string<br>    availability_zone = string<br>  }))</pre> | <pre>{<br>  "private_subnet_1": {<br>    "availability_zone": "ap-northeast-2a",<br>    "cidr_block": "10.0.3.0/24"<br>  },<br>  "private_subnet_2": {<br>    "availability_zone": "ap-northeast-2c",<br>    "cidr_block": "10.0.4.0/24"<br>  }<br>}</pre> | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | public subent | <pre>map(object({<br>    cidr_block        = string<br>    availability_zone = string<br>  }))</pre> | <pre>{<br>  "public_subnet_1": {<br>    "availability_zone": "ap-northeast-2a",<br>    "cidr_block": "10.0.1.0/24"<br>  },<br>  "public_subnet_2": {<br>    "availability_zone": "ap-northeast-2c",<br>    "cidr_block": "10.0.2.0/24"<br>  }<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
