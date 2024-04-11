# 개요
* IAM user, role을 생성하는 테라폼 코드
* [EKS IRSA 실습](../k8s_manifests/)에 사용됩니다.

# 테라폼코드 목차
* [AWS IAM User 생성](./hardcoding_user.tf)
* [AWS IAM Role 생성](./assume_role.tf)
  * [terraform 변수](./terraform.tfvars)에서 aws_root_account_id 변수 값을 여러분의 AWS account ID로 변경하세요

# 생성 방법

```sh
terraform init
terraform apply
```


# 삭제 방법

```sh
terraform destroy
```
