// --- s3 bucket for shared services config ---
data "vault_generic_secret" "shared_s3" {
  path = "aws-accounts/shared-services/s3"
}

locals {
  s3_config_bucket = data.vault_generic_secret.shared_s3.data["config_bucket_name"]
}

// ---- ECS Instance Profile ----
resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "${var.name_prefix}-ecs-instance-profile"
  path = "/"
  role = aws_iam_role.ecs-instance-role.name
  tags = local.default_tags
}

// ---- ECS Instance Role ----
resource "aws_iam_role" "ecs-instance-role" {
  name               = "${var.name_prefix}-ecs-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-instance-policy.json
  tags               = local.default_tags
}

data "aws_iam_policy_document" "ecs-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "cloudwatch-logs-policy" {
  name = "cloudwatch-logs-policy"
  role = aws_iam_role.ecs-instance-role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": ["logs:CreateLogGroup"],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "iam-pass-role-policy" {
  name = "iam-pass-role-policy"
  role = aws_iam_role.ecs-instance-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iam:GetRole",
        "iam:PassRole"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "ssm_logging_policy" {
  statement {
    sid = "SSMKMSOperations"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey"
    ]

    resources = [
      local.security_ssm_kms_key_arn
    ]
  }

  statement {
    sid = "SSMS3Operations"

    actions = [
      "s3:GetEncryptionConfiguration",
      "s3:PutObject",
      "s3:PutObjectACL"
    ]

    resources = [
      "arn:aws:s3:::${local.security_ssm_bucket_name}/*",
      "arn:aws:s3:::${local.security_ssm_bucket_name}"
    ]
  }
}

resource "aws_iam_role_policy" "ssm_logging_policy" {
  count = var.ec2_enable_ssm_logging ? 1 : 0
  name  = "ssm-logging-role-policy"
  role  = aws_iam_role.ecs-instance-role.id

  policy = data.aws_iam_policy_document.ssm_logging_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_ssm_attachment" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_cis_attachment" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonInspector2ManagedCisPolicy"
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

// ---- ECS Service Role ----

resource "aws_iam_role" "ecs-service-role" {
  name               = "${var.name_prefix}-ecs-service-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-service-policy.json
  tags               = local.default_tags
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  role       = aws_iam_role.ecs-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs-service-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy" "ecs-secrets-policy" {
  name = "ecs-secrets-policy"
  role = aws_iam_role.ecs-service-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetRole",
        "iam:PassRole",
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue",
        "kms:Decrypt"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

// ---- ECS Task Execution Role ----

resource "aws_iam_role" "ecs-task-execution-role" {
  name               = "${var.name_prefix}-ecs-task-execution-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-task-execution-policy.json
  tags               = local.default_tags
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-attachment" {
  role       = aws_iam_role.ecs-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs-task-execution-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy" "ecs-task-execution-policy" {
  name = "ecs-task-execution-policy"
  role = aws_iam_role.ecs-task-execution-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetRole",
        "iam:PassRole",
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue",
        "kms:Decrypt",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::${local.s3_config_bucket}/*/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetBucketLocation"
      ],
      "Resource": [
        "arn:aws:s3:::${local.s3_config_bucket}"
      ]
    }    
  ]
}
EOF
}

# ---- ECS Task Role ----
# To allow use of ECS Exec

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.name_prefix}-ecs-task-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_policy.json
}

data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy" "ecs_task_policy" {
  name = "ecs-task-policy"
  role = aws_iam_role.ecs_task_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ],
      "Resource": [
        "*"
      ]
    }  
  ]
}
EOF
}
