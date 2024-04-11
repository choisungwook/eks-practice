resource "aws_iam_role" "web_app" {
  name               = "web-app-assume-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.web_app_assume.json
}

data "aws_iam_policy_document" "web_app_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_root_account_id}:root"]
    }
  }
}

resource "aws_iam_role_policy" "web_app_s3" {
  name   = "web-app-s3-access"
  role   = aws_iam_role.web_app.id
  policy = data.aws_iam_policy_document.web_app_policy.json
}

data "aws_iam_policy_document" "web_app_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:List*",
      "s3:Get*"
    ]
    resources = ["*"]
  }
}
