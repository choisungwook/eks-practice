# 개요
* AWS S3 버킷을 조회하는 파이썬 웹 애플리케이션
* EC2 인스턴스 프로파일 또는 IRSA IAM role를 사용하는 예제

# 실행 방법

1. EC2 인스턴스 프로파일 또는 IRSA IAM role에 S3접근 권한 추가

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:List*",
                "s3:Get*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
```

2. 파이썬 패키지 설치

```sh
pip install -r requirements.txt
```

3. FastAPI 웹 애플리케이션 실행

```sh
cd app
uvicorn main:app
```

4. 테스트

```sh
curl 127.0.0.1:8000/buckets
```
