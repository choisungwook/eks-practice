# 개요
* dvwa를 EKS 클러스터에 배포

> 참고자료: https://github.com/cytopia/docker-dvwa/tree/master/k8s

# 전제조건
* EKS 클러스터

# 주의사항
* AWS NLB가 배포되어 추가요금이 부과됩니다.

# 실행방법
* 배포
```bash
kubectl apply -f ./
```

* AWS NLB주소로 접속
* DB setup
* 로그인 -> admin / password

# 삭제 방법
```bash
kubectl delete -f ./
```