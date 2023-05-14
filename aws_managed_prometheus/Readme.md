# 개요
EKS prometheus와 AWS Managed Prometheus 연동 예제

# 사전준비
## prometheus namespace 생성
```shell
NAMESPACE="prometheus"
kubectl create ns $NAMESPACE
```

## EKS OIDC provider 생성
```shell
CLUSTER_NAME="basic-cluster"
eksctl utils associate-iam-oidc-provider --cluster ${CLUSTER_NAME} --approve
```

## IRSA 생성
```shell
NAMESPACE="prometheus"
EKS_CLUSTER_NAME="basic-cluster"
SERVICEACCOUNT_NAME="amp-iamproxy-ingest-role"

eksctl create iamserviceaccount \
	--name ${SERVICEACCOUNT_NAME} \
	--namespace ${NAMESPACE} \
	--cluster ${EKS_CLUSTER_NAME} \
	--attach-policy-arn arn:aws:iam::aws:policy/AmazonPrometheusRemoteWriteAccess \
	--approve
```

# 연동방법
## AWS Managed prometheus 생성

## prometheus operator helm 차트 추가
```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

## values.yaml 생성
```shell
eks_cluster_name="test-eks"
irsa_serviceaccount="amp-iamproxy-ingest-role"
amp_workspace_id=$(aws amp list-workspaces --alias $eks_cluster_name | jq .workspaces[0].workspaceId -r)
aws_region="ap-northeast-2"

cat <<EOT > values.yaml
alertmanager:
  enabled: false

grafana:
  enabled: false

prometheus:
  serviceAccount:
    create: false
    name: $irsa_serviceaccount

  ingress:
    enabled: false

  prometheusSpec:
    podMonitorSelectorNilUsesHelmValues: false
    serviceMonitorSelectorNilUsesHelmValues: false
    retention: 1d
    retentionSize: "10GiB"
    scrapeInterval: 15s
    evaluationInterval: 15s
    remoteWrite:
    - url: https://aps-workspaces.$aws_region.amazonaws.com/workspaces/$amp_workspace_id/api/v1/remote_write
      sigv4:
        region: $aws_region
      queueConfig:
        maxSamplesPerSend: 1000
        maxShards: 200
        capacity: 2500
EOT
```

## helm chart 릴리즈
```shell
NAMESPACE="prometheus"

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
--namespace ${NAMESPACE} \
--version 45.7.1 \
-f values.yaml
```

## prometheus 로그 확인
* error로그가 없어야 함
```shell
NAMESPACE="prometheus"
kubectl -n ${NAMESPACE} logs -f
```

# 삭제
```shell
helm uninstall -n prometheus kube-prometheus-stack
```
