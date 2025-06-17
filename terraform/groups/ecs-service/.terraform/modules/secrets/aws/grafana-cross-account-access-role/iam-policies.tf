resource "aws_iam_policy" "cloudwatch" {
  name   = "${aws_iam_role.this.name}-cloudwatch"
  policy = data.aws_iam_policy_document.cloudwatch.json
}
