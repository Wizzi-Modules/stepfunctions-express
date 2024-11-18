resource "aws_iam_role" "this" {
  name = "${var.name_prefix}-${var.environment}-stepfunctions"
  assume_role_policy = file("${path.module}/policies/stepfunctions-assume-role-policy.json")
}

data "aws_region" "this" {}
data "aws_caller_identity" "this" {}

resource "aws_iam_role_policy" "logging_configuration" {
  name = "${var.environment}-stepfunctions-logging"
  role = aws_iam_role.this.id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
            "logs:CreateLogDelivery",
            "logs:GetLogDelivery",
            "logs:UpdateLogDelivery",
            "logs:DeleteLogDelivery",
            "logs:ListLogDeliveries",
            "logs:PutResourcePolicy",
            "logs:DescribeResourcePolicies",
            "logs:DescribeLogGroups"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "xray" {
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
  role = aws_iam_role.this.name
}

resource "aws_iam_role_policy" "code_policy" {
  for_each = fileset("${var.folder}/policies", "*.json")

  name = "${var.environment}-${split(".", each.key)[0]}-stepfunctions"

  policy = templatefile("${var.folder}/policies/${each.key}", {
    env    = var.environment,
    aws_id = data.aws_caller_identity.this.account_id,
    region = data.aws_region.this.name
  })

  role = aws_iam_role.this.id
}