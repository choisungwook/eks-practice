# 개요
* istio https NLB 예제

# 전제조건
* istioctl 설치
* http 인증서

# istio 설치
```bash
istioctl install -f istio-operator.yaml
```

# 인증서 생성
```bash
kubectl -n istio-system create secret tls tls-secret \
  --cert=path/to/cert/file \
  --key=path/to/key/file
```

# 예제 생성
```bash
kubectl apply -f gateway.yaml
kubectl apply -f virtual-service.yaml
kubectl apply -f example.yaml
```

# 삭제
- 예제 삭제
```bash
kubectl delete -f gateway.yaml
kubectl delete -f virtual-service.yaml
kubectl delete -f example.yaml
```

- istio 삭제
```bash
istioctl uninstall --purge
```

# 참고자료
* https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/3000#issuecomment-1420668597
* https://nyyang.tistory.com/158
* https://istio.io/latest/docs/setup/install/istioctl/
* https://www.clud.me/11354dd3-48f3-454d-917f-eca8d975e034
* https://itnp.kr/post/install-istio