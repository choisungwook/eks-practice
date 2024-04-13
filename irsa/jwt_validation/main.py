import jwt
import requests
from jwt.algorithms import RSAAlgorithm
from dotenv import load_dotenv
import os

# 환경변수 로드
load_dotenv()

def get_aws_public_keys():
  """
  환경변수에서 설정된 AWS의 JWKS (JSON Web Key Set) 엔드포인트에서 공개 키들을 가져옵니다.
  반환값은 key ID ('kid')를 키로 하고 해당 JWKS에서 파싱된 공개 키를 값으로 하는 딕셔너리입니다.

  Returns:
      dict: 공개 키들을 담고 있는 딕셔너리.
  """
  oidc_provider_url = os.getenv('EKS_OIDC_PROVIDER_URL')
  response = requests.get(f"{oidc_provider_url}/keys")
  keys = response.json()["keys"]

  return {key["kid"]: RSAAlgorithm.from_jwk(key) for key in keys}

def verify_eks_irsa_token(token):
  """
  주어진 JWT 토큰을 검증합니다. 토큰의 'kid' 헤더를 사용하여 적절한 AWS 공개 키를 선택하고,
  해당 키를 사용하여 토큰의 서명을 검증합니다. 토큰이 유효하면 페이로드를 반환하고,
  그렇지 않으면 오류 메시지를 반환합니다.

  Args:
      token (str): 검증할 JWT 토큰.

  Returns:
      dict or str: 디코딩된 토큰 페이로드 또는 오류 메시지.
  """
  try:
    # AWS 공개 키 가져오기
    public_keys = get_aws_public_keys()

    # 토큰에서 'kid' 헤더 추출
    headers = jwt.get_unverified_header(token)
    key_id = headers["kid"]

    # 적합한 공개 키로 서명 검증
    public_key = public_keys[key_id]
    jwt.decode(token, public_key, algorithms=["RS256"], audience="sts.amazonaws.com")

    return "JWT is valid"
  except jwt.ExpiredSignatureError:
    return "Token has expired"
  except jwt.JWTClaimsError:
    return "Invalid claims, please check the audience and issuer"
  except Exception as e:
    return str(e)

if __name__ == "__main__":
  token = os.getenv('JWT_TOKEN')
  result = verify_eks_irsa_token(token)

  print(result)
