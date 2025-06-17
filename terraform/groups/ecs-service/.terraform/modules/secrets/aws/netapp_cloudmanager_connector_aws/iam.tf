# Role policy documents based on examples provided at https://docs.netapp.com/us-en/occm/media/c2s.pdf
# Both policies are attached to a single role as it appears that the CVO resource only supports a single
# role input for both data and mediator nodes.

resource "aws_iam_instance_profile" "this" {
  name = format("%s-%s", "ipro", var.name)
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name = format("%s-%s", "irol", var.name)

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

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_policy" "this" {
  name        = format("%s-%s", "ipol", var.name)
  description = "Policy for Cloud Manager Connector instances"

  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {

  dynamic "statement" {
    for_each = toset(var.cvo_connector_role_names)

    content {
      actions = [
        "sts:AssumeRole",
      ]
      resources = [for account in local.netapp_cvo_accountIds : format("arn:aws:iam::%s:role/${statement.value}", account)]
      effect    = "Allow"
    }
  }

  statement {
    actions = [
      "iam:ListInstanceProfiles",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:PutRolePolicy",
      "iam:CreateInstanceProfile",
      "iam:DeleteRolePolicy",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:DeleteInstanceProfile",
      "ec2:ModifyVolumeAttribute",
      "sts:DecodeAuthorizationMessage",
      "ec2:DescribeImages",
      "ec2:DescribeRouteTables",
      "ec2:DescribeInstances",
      "iam:PassRole",
      "iam:TagRole",
      "ec2:DescribeInstanceStatus",
      "ec2:RunInstances",
      "ec2:ModifyInstanceAttribute",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DescribeVolumes",
      "ec2:DeleteVolume",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeSecurityGroups",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:DescribeDhcpOptions",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot",
      "ec2:DescribeSnapshots",
      "ec2:StopInstances",
      "ec2:GetConsoleOutput",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeRegions",
      "ec2:DeleteTags",
      "ec2:DescribeTags",
      "ec2:DescribeVolumesModifications",
      "ec2:ModifyVolume",
      "cloudformation:CreateStack",
      "cloudformation:DeleteStack",
      "cloudformation:DescribeStacks",
      "cloudformation:DescribeStackEvents",
      "cloudformation:ValidateTemplate",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "s3:GetBucketTagging",
      "s3:GetBucketLocation",
      "s3:CreateBucket",
      "s3:GetBucketPolicyStatus",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy",
      "kms:List*",
      "kms:ReEncrypt*",
      "kms:Describe*",
      "kms:CreateGrant",
      "ec2:AssociateIamInstanceProfile",
      "ec2:DescribeIamInstanceProfileAssociations",
      "ec2:DisassociateIamInstanceProfile",
      "ec2:DescribeInstanceAttribute",
      "ce:GetReservationUtilization",
      "ce:GetDimensionValues",
      "ce:GetCostAndUsage",
      "ce:GetTags",
      "ec2:CreatePlacementGroup",
      "ec2:DeletePlacementGroup"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "fabricPoolPolicy"
    actions = [
      "s3:DeleteBucket",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:PutBucketTagging",
      "s3:ListBucketVersions",
      "s3:GetBucketPolicyStatus",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy",
      "s3:PutBucketPublicAccessBlock"
    ]
    resources = ["arn:aws:s3:::fabric-pool*"]
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

  statement {
    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "ec2:AttachVolume",
      "ec2:DetachVolume"
    ]
    resources = ["arn:aws:ec2:*:*:instance/*"]
    effect    = "Allow"

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CloudManager-Managed"
      values = [
        "True",
      ]
    }
  }

  statement {
    actions = [
      "ec2:AttachVolume",
      "ec2:DetachVolume"
    ]
    resources = ["arn:aws:ec2:*:*:volume/*"]
    effect    = "Allow"
  }
}
