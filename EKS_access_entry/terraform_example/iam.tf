resource "aws_iam_role" "access_entry_test_role" {
  name               = "access_entry_test_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.access_entry_test_role_assume.json
}

data "aws_iam_policy_document" "access_entry_test_role_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_root_account_id}:root"]
    }
  }
}

resource "aws_iam_role_policy" "access_entry_test_role" {
  name   = "access_entry_test_role"
  role   = aws_iam_role.access_entry_test_role.id
  policy = data.aws_iam_policy_document.access_entry_test_role.json
}

data "aws_iam_policy_document" "access_entry_test_role" {
  statement {
    effect = "Allow"
    actions = [
      "eks:ListClusters",
      "eks:DescribeCluster",
      "eks:ListAccessEntries",
      "eks:DescribeAccessEntry",
      "eks:ListPodIdentityAssociations",
      "eks:ListIdentityProviderConfigs",
      "eks:ListAssociatedAccessPolicies"
    ]
    resources = ["*"]
  }
}
