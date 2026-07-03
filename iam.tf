# IAM Roles and Policies for Hospital Hybrid Deployment

# 1. AWS IoT Greengrass Token Exchange Role
resource "aws_iam_role" "greengrass_token_exchange_role" {
  name = "HospitalEdgeGreengrassTokenExchangeRole-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "credentials.iot.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.common_tags
}

# 2. IAM Policy for Greengrass Token Exchange Role (allows S3 access, CloudWatch logs, IoT operations)
resource "aws_iam_policy" "greengrass_token_exchange_policy" {
  name        = "HospitalEdgeGreengrassTokenExchangePolicy-${var.environment}"
  description = "Allows local Greengrass gateways to fetch configurations, access S3 artifacts, and push logs."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Access to AWS IoT Core
      {
        Effect = "Allow"
        Action = [
          "iot:Publish",
          "iot:Subscribe",
          "iot:Connect",
          "iot:Receive",
          "iot:GetThingShadow",
          "iot:UpdateThingShadow",
          "iot:DeleteThingShadow"
        ]
        Resource = "*"
      },
      # Access to component storage buckets
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "arn:aws:s3:::*.greengrass.artifacts*",
          "arn:aws:s3:::gcs-greengrass-*"
        ]
      },
      # CloudWatch logs access
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "greengrass_attach" {
  role       = aws_iam_role.greengrass_token_exchange_role.name
  policy_arn = aws_iam_policy.greengrass_token_exchange_policy.arn
}

# 3. Role Alias for AWS IoT Core Credentials Provider
# This allows the Greengrass Core to request credentials using a role alias instead of hardcoded credentials.
resource "aws_iot_role_alias" "greengrass_role_alias" {
  alias    = "HospitalEdgeGreengrassTokenExchangeRoleAlias"
  role_arn = aws_iam_role.greengrass_token_exchange_role.arn
}
