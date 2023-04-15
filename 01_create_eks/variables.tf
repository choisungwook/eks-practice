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

variable "vpc-cidr" {
  type        = string
  description = "vpc cidr"
  default     = "10.0.0.0/16"
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

variable "eks-worker-nodes-desired-size" {
  type        = number
  description = "EKS worker nodes desired size"
  default     = 3
}

variable "eks-worker-nodes-min-size" {
  type        = number
  description = "EKS worker nodes min size"
  default     = 2
}

variable "eks-worker-nodes-max-size" {
  type        = number
  description = "EKS worker nodes max size"
  default     = 3
}

# reference: https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/retrieve-ami-id.html
variable "eks-worker-nodes-ami-id" {
  type        = string
  description = "EKS worker nodes ami"
  default     = "ami-0077d69c7df3f4949"
}

variable "eks-worker-nodes-instance-type" {
  type        = string
  description = "EKS worker nodes max size"
  default     = "t2.medium"
}

variable "eks-worker-nodes-disk-size" {
  type        = string
  description = "EKS worker nodes disk size"
  default     = "20"
}
