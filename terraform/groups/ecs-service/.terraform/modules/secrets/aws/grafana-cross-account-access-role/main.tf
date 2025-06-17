resource "aws_iam_role" "this" {
  name               = "Grafana-DataSource-Access"
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.cloudwatch.arn
}

