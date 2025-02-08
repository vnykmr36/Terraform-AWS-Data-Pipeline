resource "aws_iam_policy" "dms-kms-secrets-policy" {
  name = "dms-secrets-kms-access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["secretsmanager:*"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Effect : "Allow",
        Action : "kms:*",
        Resource : "*",
      },
      {
        Effect : "Allow",
        Action : "s3:*"
        Resource : "*",
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role" "secrets_ret" {
  name = "dms_get_secrets"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AccessforDMS"
        Principal = {
          Service = "dms.${var.environment.region}.amazonaws.com"
        }
      },
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.secrets_ret.name
  policy_arn = aws_iam_policy.dms-kms-secrets-policy.arn
}