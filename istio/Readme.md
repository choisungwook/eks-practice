# 개요
* istio 설치

# 전제조건
* alb controller 설치
* aws ACM 리소스
* aws route53

# istioctl 설치
```bash
curl -L https://istio.io/downloadIstio | sh -
export PATH=$HOME/.istioctl/bin:$PATH
```

# istio 설치
```bash
istioctl install -f istio-operator.yaml
```

* 확인
```bash
kubectl get pods -n istio-system
```

# 삭제
```bash
istioctl uninstall --purge
```

# 참고자료
* https://istio.io/latest/docs/setup/install/istioctl/
* https://www.clud.me/11354dd3-48f3-454d-917f-eca8d975e034
* https://itnp.kr/post/install-istio