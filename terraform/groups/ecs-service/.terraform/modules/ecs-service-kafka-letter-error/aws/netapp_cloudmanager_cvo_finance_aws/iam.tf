# Role policy documents based on examples provided at https://docs.netapp.com/us-en/occm/media/c2s.pdf
# Both policies are attached to a single role as it appears that the CVO resource only supports a single
# role input for both data and mediator nodes.

resource "aws_iam_instance_profile" "this" {
  name = format("%s-%s", "ipro", local.name)
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name = format("%s-%s", "irol", local.name)

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": "InstanceProfileAssume"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cvo" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.cvo.arn
}

resource "aws_iam_policy" "cvo" {
  name        = format("%s-%s-%s", "ipol", local.name, "cvo")
  description = "Policy for Cloud Volumes ONTAP instances"

  policy = data.aws_iam_policy_document.cvo.json
}

data "aws_iam_policy_document" "cvo" {
  statement {
    actions = ["s3:ListAllMyBuckets"]
    resources = [
      "arn:aws:s3:::*",
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = ["arn:aws:s3:::fabric-pool-*"]
    effect    = "Allow"
  }

  statement {
    sid = ""
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["arn:aws:s3:::fabric-pool-*"]
    effect    = "Allow"
  }

  statement {
    sid = "backupPolicy"
    actions = [
      "s3:DeleteBucket",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:PutBucketTagging",
      "s3:ListBucketVersions",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "s3:GetBucketTagging",
      "s3:GetBucketLocation",
      "s3:GetBucketPolicyStatus",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy",
      "s3:PutBucketPublicAccessBlock"
    ]
    resources = ["arn:aws:s3:::netapp-backup-*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "cvo_ha_mediator" {
  count = var.is_ha ? 1 : 0

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.cvo_ha_mediator[0].arn
}

resource "aws_iam_policy" "cvo_ha_mediator" {
  count = var.is_ha ? 1 : 0

  name        = format("%s-%s-%s", "ipol", local.name, "cvo-ha-mediator")
  description = "Policy for the Cloud Volumes ONTAP HA mediator instance"

  policy = data.aws_iam_policy_document.cvo_ha_mediator[0].json
}

data "aws_iam_policy_document" "cvo_ha_mediator" {
  count = var.is_ha ? 1 : 0

  statement {
    actions = [
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeRouteTables",
      "ec2:DescribeVpcs",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  dynamic "statement" {
    # We dont care about the result of the for_each, we are using it to conditionally create this block if the list is not empty.
    for_each = length(try(var.route_table_ids, [])) >= 1 ? [""] : []
    content {
      sid = "Write"
      actions = [
        "ec2:ReplaceRoute",
        "ec2:CreateRoute",
        "ec2:DeleteRoute",
      ]
      resources = formatlist("arn:aws:ec2:%s:%s:route-table/%s", data.aws_region.current.name, data.aws_caller_identity.current.account_id, var.route_table_ids)
    }
  }
}
