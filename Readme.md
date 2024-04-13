# 1. 개요
테라폼으로 EKS를 생성하는 예제입니다.

# 2. 준비
* IAM Administrator role
* kubectl
* eksctl

# 3. 목차
* [eksctl로 cluster생성](./01_create_eks_cluster/)
* [eksctl로 fargate nodegroup 생성](./02_fargate_nodegroup/)
* [control plane logging 활성화](./03_eks_logging/)
* [aws managed prometheus](./aws_managed_prometheus/)
* [dvwa 웹 애플리케이션](./dvwa_webapp/)
* [external dns](./external_dns/)
* [alb controller](./alb_controller/)
* [istio with istioctl](./istio/)
* [IRSA 예제](./irsa)
* [EKS IRSA JWT 토큰 검증하는 파이썬코드](./irsa/jwt_validation)
