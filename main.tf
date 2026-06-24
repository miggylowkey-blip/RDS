terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Module - with free-tier settings
module "vpc" {
  source = "./vpc"

  client_name         = var.client_name
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  enable_nat          = false  # Free-tier: no NAT gateway
  trusted_ssh_cidr    = var.trusted_ssh_cidr
  db_port             = var.db_port
  allow_public_http   = var.allow_public_http
  tags                = var.common_tags
}

# EC2 Module (Bastion) - for secure access to private resources
module "ec2_bastion" {
  source = "./ec2"

  subnet_id              = module.vpc.public_subnet_ids[0]
  security_group_id      = module.vpc.bastion_security_group_id
  instance_type          = var.bastion_instance_type
  instance_name          = "${var.client_name}-${var.environment}-bastion"
  associate_public_ip    = true  # Bastion needs public IP for inbound SSH
  key_name               = var.ec2_key_name
  iam_instance_profile   = var.bastion_iam_instance_profile
  vpc_id                 = module.vpc.vpc_id
  tags                   = var.common_tags
}

# Optional: Application EC2 in private subnet (no public IP)
module "ec2_app" {
  count  = var.deploy_app_instance ? 1 : 0
  source = "./ec2"

  subnet_id              = module.vpc.private_subnet_ids[0]
  security_group_id      = module.vpc.app_security_group_id
  instance_type          = var.app_instance_type
  instance_name          = "${var.client_name}-${var.environment}-app"
  associate_public_ip    = false  # Private subnet, no public IP
  key_name               = null
  iam_instance_profile   = var.app_iam_instance_profile
  vpc_id                 = module.vpc.vpc_id
  tags                   = var.common_tags
}
