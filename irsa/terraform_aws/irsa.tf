resource "aws_iam_role" "irsa_web_app" {
  count = var.oidc_provider_arn != "" ? 1 : 0

  name               = "irsa-web-app"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.irsa_web_app_assume[0].json
}

data "aws_iam_policy_document" "irsa_web_app_assume" {
  count = var.oidc_provider_arn != "" ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["${var.oidc_provider_arn}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${var.oidc_connect_url}:sub"
      values   = ["system:serviceaccount:${var.serviceaccount_with_namespace}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${var.oidc_connect_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "irsa_web_app_s3" {
  count = var.oidc_provider_arn != "" ? 1 : 0

  name   = "irsa-web-app-s3-access"
  role   = aws_iam_role.irsa_web_app[0].id
  policy = data.aws_iam_policy_document.irsa_web_app_policy[0].json
}

data "aws_iam_policy_document" "irsa_web_app_policy" {
  count = var.oidc_provider_arn != "" ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "s3:List*",
      "s3:Get*"
    ]
    resources = ["*"]
  }
}
