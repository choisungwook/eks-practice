from fastapi import FastAPI
import boto3
import os

app = FastAPI()

@app.get("/buckets")
def get_buckets():
  try:
    session = boto3.Session()
    sts_client = session.client('sts')
    assumed_role = sts_client.assume_role(
      RoleArn=os.environ.get('ASSUME_ROLE_ARN'),
      RoleSessionName='AssumedRoleSession'
    )

    credentials = assumed_role['Credentials']
    s3_client = boto3.client(
      's3',
      aws_access_key_id=credentials['AccessKeyId'],
      aws_secret_access_key=credentials['SecretAccessKey'],
      aws_session_token=credentials['SessionToken']
    )

    response = s3_client.list_buckets()
    buckets = [bucket['Name'] for bucket in response['Buckets']]

    return {"buckets": buckets}
  except Exception as e:
    return {"error": str(e)}


@app.get("/health")
def get_healthcheck():
    return {"status": "ok"}
