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

# 예제 목록
- [nlb with https](./nlb-https-example/)
