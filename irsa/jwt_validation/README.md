# 개요
* EKS IRSA JWT 토큰 검증하는 파이썬코드

# 사전지식
* EKS IRSA 동작원리

# 실행방법

1. 파이썬 패키지 설치

```sh
pip install -r requirements.txt
```

2. EKS OIDC identity provider URL을 .env파일에 설정

```sh
$ cat .env
EKS_OIDC_PROVIDER_URL="xxxxxxx"
```

3. pod JWT을 .env에 설정

```sh
$ cat .env
JWT_TOKEN="xxxxxxx"
```

4. 파이썬 코드 실행 - "JWT is valid"메세지가 나오면 JWT검증 성공
