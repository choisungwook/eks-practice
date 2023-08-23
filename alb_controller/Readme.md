# 개요
* alb controller 설치

# 전제조건
* aws Route 53에 host zone 등록
* aws ACM 생성

# 설치
## 1. IAM policy 생성
```bash
aws iam create-policy \
  --policy-name "AWSLoadBalancerControllerIAMPolicy" \
  --policy-document file://policy.json
```

## 2. odic provider 생성
```bash
CLUSTER_NAME="basic-cluster"
eksctl utils associate-iam-oidc-provider --cluster ${CLUSTER_NAME} --approve
```

## 3. IRSA 생성
```bash
POLICY_ARN=$(aws iam list-policies --query 'Policies[?PolicyName==`AWSLoadBalancerControllerIAMPolicy`].Arn' --output text)
ROLE_NAME="AmazonEKSLoadBalancerControllerRole"
CLUSTER_NAME="basic-cluster"

eksctl create iamserviceaccount \
  --cluster ${CLUSTER_NAME} \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name ${ROLE_NAME} \
  --attach-policy-arn=${POLICY_ARN} \
  --approve
```

## 4. helm repo 추가
```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update
```

## 5. helm 차트 release
```bash
CLUSTER_NAME="basic-cluster"

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=${CLUSTER_NAME} \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```

# 예제 배포
* [NLB](././nlb_example.yaml)
* [ALB](./alb_example.yaml)


# 삭제
> 배포했던 예제를 꼭 삭제 후에 alb controller을 삭제해주세요

```bash
helm -n kube-system delete aws-load-balancer-controller
```
