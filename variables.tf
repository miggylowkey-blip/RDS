variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "ap-southeast-2"
}

variable "client_name" {
  type        = string
  description = "Client or project name for resource naming"
  default     = "myapp"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g. dev, staging, prod)"
  default     = "dev"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "AWS availability zones to use"
  default     = ["ap-southeast-2a", "ap-southeast-2b"]
}

variable "trusted_ssh_cidr" {
  type        = string
  description = "CIDR block allowed to SSH to bastion (set to your office/home IP)"
  default     = "0.0.0.0/0"  # CHANGE THIS to your IP for security!
}

variable "db_port" {
  type        = number
  description = "Database port (e.g. 5432 for Postgres)"
  default     = 5432
}

variable "allow_public_http" {
  type        = bool
  description = "Allow public HTTP to app SG"
  default     = false
}

variable "bastion_instance_type" {
  type        = string
  description = "EC2 instance type for bastion"
  default     = "t2.micro"
}

variable "app_instance_type" {
  type        = string
  description = "EC2 instance type for app server"
  default     = "t2.micro"
}

variable "deploy_app_instance" {
  type        = bool
  description = "Whether to deploy an optional app instance in private subnet"
  default     = false
}

variable "ec2_key_name" {
  type        = string
  description = "EC2 key pair name for bastion SSH access"
  default     = null
}

variable "bastion_iam_instance_profile" {
  type        = string
  description = "IAM instance profile for bastion (optional, for SSM access)"
  default     = null
}

variable "app_iam_instance_profile" {
  type        = string
  description = "IAM instance profile for app instance (optional, for SSM/DB access)"
  default     = null
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all resources"
  default = {
    ManagedBy = "Terraform"
    Project   = "Database-RDS"
  }
}

variable "db_password" {
  type        = string
  description = "Password for the RDS cloud database"
  sensitive   = true
  default     = "CloudSecurePasswordBackup123!" # In production, set this via secrets/env
}

