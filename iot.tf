# AWS IoT Core Resources for managing Greengrass edge gateways

# 1. Thing Type for Edge Gateways
resource "aws_iot_thing_type" "gateway_type" {
  name = "HospitalEdgeGatewayType"
  
  properties {
    description = "Hardware Edge Gateways installed on-premises in hospitals"
  }
}

# 2. IoT Thing representing the primary local edge gateway
resource "aws_iot_thing" "edge_gateway" {
  name            = "HospitalEdgeGateway-01-${var.environment}"
  thing_type_name = aws_iot_thing_type.gateway_type.name

  attributes = {
    Environment = var.environment
    Location    = "Main-Campus"
  }
}

# 3. IoT Thing Group for deploying patches/configurations to all gateways in bulk
resource "aws_iot_thing_group" "gateway_group" {
  name = "HospitalEdgeGateways-${var.environment}"

  properties {
    description = "Group containing all active on-premises hospital edge gateways"
  }
}

resource "aws_iot_thing_principal_attachment" "example_attachment" {
  count     = 0 # Placeholder for attaching the client certificates when generated/provisioned
  principal = "arn:aws:iot:ap-southeast-2:123456789012:cert/some-certificate-hash"
  thing     = aws_iot_thing.edge_gateway.name
}

# 4. AWS IoT Security Policy for the Edge Gateway certificates
# Allows the physical gateway to connect to AWS IoT Core, retrieve job documents, and synchronize shadows
resource "aws_iot_policy" "greengrass_iot_policy" {
  name = "HospitalEdgeGreengrassIoTPolicy-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Standard IoT MQTT connection permissions
      {
        Effect = "Allow"
        Action = [
          "iot:Connect",
          "iot:Publish",
          "iot:Subscribe",
          "iot:Receive"
        ]
        Resource = "*"
      },
      # Retrieve shadow updates (e.g. configuration sync)
      {
        Effect = "Allow"
        Action = [
          "iot:GetThingShadow",
          "iot:UpdateThingShadow"
        ]
        Resource = "arn:aws:iot:*:*:thing/${aws_iot_thing.edge_gateway.name}"
      },
      # Greengrass core deployment and jobs access
      {
        Effect = "Allow"
        Action = [
          "greengrass:GetComponentVersionArtifact",
          "greengrass:ResolveComponentCandidates",
          "iot:DescribeJobExecution",
          "iot:GetPendingJobExecutions",
          "iot:StartNextPendingJobExecution",
          "iot:UpdateJobExecution"
        ]
        Resource = "*"
      }
    ]
  })
}
