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
* manifest 파일 수정 -> service annotations필드를 수정
```bash
vi example.yaml

apiVersion: v1
kind: Service
metadata:
  name: echo-server
  namespace: default
  annotations:
    ...
    external-dns.alpha.kubernetes.io/hostname: "change here" # aws route53 hostzone
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "change here" # aws acm id

```

* manifest 배포 - NLB 생성
```bash
kubectl -n defualt apply -f example.yaml
```

* 쿠버네티스 service에 EXTERNAL-IP확인(pending이면 ALB controller 설치가 잘못됨)
```bash
kubectl -n default get svc
NAME ...      EXTERNAL-IP
echo-server   someting.ap-northeast-2.amazonaws.com
```

* 웹 브라우저에서 aws NLB dns주소로 접속

# 삭제
* 예제 삭제
```bash
kubectl -n default delete -f example.yaml
```

```bash
helm -n kube-system delete aws-load-balancer-controller
```