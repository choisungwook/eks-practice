# 개요
AWS Managed prometheus 설치연습

# 사전준비
* IRSA에 사용할 AWS IAM role
* AWS ALB controller
* external dns
* AWS Managed prometheus 생성
* AWS route53

# 실행방법
* values.yaml 업데이트
```shell
your_host="your_route53_hostzone"
your_role_arn="your_IRSA_role"
your_amp_url="your_managed_proemtheus_url"
your_region="ap-northeast-2"

cat <<EOT > valeus.yaml
alertmanager:
  enabled: false

grafana:
  defaultDashboardsTimezone: Asia/Seoul
  adminPassword: prom-operator

  ingress:
    enabled: true
    ingressClassName: alb

    annotations:
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}, {"HTTP":80}]'
      alb.ingress.kubernetes.io/success-codes: 200-399
      alb.ingress.kubernetes.io/group.name: "prometheus-operator"

    hosts:
    - grafana.${your_host}

    paths:
    - /*

prometheus:
  serviceAccount:
    name: amp-test-user
    annotations:
      eks.amazonaws.com/role-arn: ${your_role_arn}
  ingress:
    enabled: true
    ingressClassName: alb

    annotations:
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}, {"HTTP":80}]'
      alb.ingress.kubernetes.io/success-codes: 200-399
      alb.ingress.kubernetes.io/group.name: "prometheus-operator"

    hosts:
    - prometheus.${your_host}

    paths:
    - /*

  prometheusSpec:
    podMonitorSelectorNilUsesHelmValues: false
    serviceMonitorSelectorNilUsesHelmValues: false
    retention: 1d
    retentionSize: "10GiB"
    scrapeInterval: 15s
    evaluationInterval: 15s
    remoteWrite:
    - url: ${your_amp_url}
      sigv4:
        region: ${your_region}
      queueConfig:
        maxSamplesPerSend: 1000
        maxShards: 200
        capacity: 2500
EOT
```


* helm 차트 릴리즈
```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

```shell
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
--version 45.7.1 \
-f values.yaml \
--namespace prometheus --create-namespace
```

# 삭제 방법
```shell
helm uninstall -n prometheus kube-prometheus-stack
```
