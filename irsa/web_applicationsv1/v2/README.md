# 개요
* AWS S3 버킷을 조회하는 파이썬 웹 애플리케이션
* ACCESES_KEY, SECRET_KEY 하드코딩

# 실행 방법

1. AWS IAM Role 생성과 Assume Role설정, S3 버킷권한 추가([테라폼 코드](../../terraform_aws/hardcoding_user.tf)를 참고)

2. 환경변수 초기화

```sh
export ASSUME_ROLE_ARN=""
```

3. 파이썬 패키지 설치

```sh
pip install -r requirements.txt
```

4. FastAPI 웹 애플리케이션 실행

```sh
cd app
uvicorn main:app
```

5. 테스트

```sh
curl 127.0.0.1:8000/buckets
```
