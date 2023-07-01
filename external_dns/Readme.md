# 개요
* external dns 설치

# 전제조건
* aws route 53에 host zone 등록

# 설치
## 1. IAM policy 생성
```bash
aws iam create-policy --policy-name "AllowExternalDNSUpdates" --policy-document file://policy.json
```

## 2. odic provider 생성
```bash
CLUSTER_NAME="basic-cluster"
eksctl utils associate-iam-oidc-provider --cluster ${CLUSTER_NAME} --approve
```

## 3. namespace 생성
```bash
export EXTERNALDNS_NS="externaldns"
kubectl create namespace $EXTERNALDNS_NS
```

## 4. IRSA 생성
```bash
POLICY_ARN=$(aws iam list-policies --query 'Policies[?PolicyName==`AllowExternalDNSUpdates`].Arn' --output text)
CLUSTER_NAME="basic-cluster"
EXTERNALDNS_NS="externaldns"

eksctl create iamserviceaccount \
  --cluster $CLUSTER_NAME \
  --name "external-dns" \
  --namespace ${EXTERNALDNS_NS} \
  --attach-policy-arn $POLICY_ARN \
  --approve
```

## 5. manifest 수정
```bash
vi manifest.yaml
```

## 6. mainfest 배포
```bash
export EXTERNALDNS_NS="externaldns"
kubectl -n $EXTERNALDNS_NS apply -f manifest.yaml
```


# 참고자료
* https://repost.aws/ko/knowledge-center/eks-set-up-externaldns