resource "aws_iam_user" "irsa" {
  name = "irsa-test"
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3_access_policy"
  description = "Allows listing and getting all S3 buckets"
  policy      = data.aws_iam_policy_document.s3_access_policy.json
}

resource "aws_iam_user_policy_attachment" "s3_access_attachment" {
  user       = aws_iam_user.irsa.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:List*",
      "s3:Get*"
    ]
    resources = ["*"]
  }
}
