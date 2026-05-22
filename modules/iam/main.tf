 
resource "aws_iam_role" "ec2_role" {
  name        = "${var.project_name}-${var.environment}-ec2-role"
  description = "Role assumed by EC2 instances in ${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "ec2_s3_policy" {
  name = "${var.project_name}-${var.environment}-s3-access"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3ProjectBucketAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "ec2_cloudwatch_policy" {
  name = "${var.project_name}-${var.environment}-cloudwatch-logs"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Sid    = "CloudWatchMetrics"
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name
  tags = var.tags
}

resource "aws_iam_user" "deploy_user" {
  count = var.create_deploy_user ? 1 : 0
  name  = "${var.project_name}-${var.environment}-deploy-user"
  path  = "/ci/"
  tags  = merge(var.tags, { Purpose = "GitHub Actions CI/CD" })
}

resource "aws_iam_user_policy" "deploy_user_policy" {
  count = var.create_deploy_user ? 1 : 0
  name  = "${var.project_name}-${var.environment}-deploy-policy"
  user  = aws_iam_user.deploy_user[0].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "TerraformStateAccess"
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:ListBucket"]
        Resource = [
          "arn:aws:s3:::${var.state_bucket_name}",
          "arn:aws:s3:::${var.state_bucket_name}/*"
        ]
      },
      {
        Sid      = "DynamoDBStateLock"
        Effect   = "Allow"
        Action   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
        Resource = "arn:aws:dynamodb:*:*:table/${var.lock_table_name}"
      },
      {
        Sid    = "EC2Deploy"
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:CreateTags"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_access_key" "deploy_user_key" {
  count = var.create_deploy_user ? 1 : 0
  user  = aws_iam_user.deploy_user[0].name
}