variable "subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    public_subnet_1 = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-northeast-2a"
    }
    public_subnet_2 = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "ap-northeast-2c"
    }
    private_subnet_1 = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "ap-northeast-2a"
    }
    private_subnet_2 = {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "ap-northeast-2c"
    }
  }
}