variable "public_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "public subent"
  default = {
    public_subnet_1 = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-northeast-2a"
    },
    public_subnet_2 = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "ap-northeast-2c"
    }
  }
}

variable "private_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "private subent"
  default = {
    private_subnet_1 = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "ap-northeast-2a"
    },
    private_subnet_2 = {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "ap-northeast-2c"
    }
  }
}

variable "eks-cluster-name" {
  type        = string
  description = "EKS cluster name"
  default     = "eks-cluster"
}

variable "eks-cluster-version" {
  type        = string
  description = "EKS cluster version"
  default     = "1.24"
}
