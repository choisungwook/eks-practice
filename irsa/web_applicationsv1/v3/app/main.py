from fastapi import FastAPI
import boto3
import os

app = FastAPI()

@app.get("/buckets")
def get_buckets():
  try:
    session = boto3.Session()
    s3_client = session.client('s3')

    response = s3_client.list_buckets()
    buckets = [bucket['Name'] for bucket in response['Buckets']]

    return {"buckets": buckets}
  except Exception as e:
    return {"error": str(e)}


@app.get("/health")
def get_healthcheck():
    return {"status": "ok"}
