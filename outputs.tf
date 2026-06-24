# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = var.vpc_cidr
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "db_subnet_group" {
  description = "DB subnet group name for RDS"
  value       = module.vpc.db_subnet_group
}

# Security Group Outputs
output "app_security_group_id" {
  description = "Application security group ID"
  value       = module.vpc.app_security_group_id
}

output "bastion_security_group_id" {
  description = "Bastion security group ID"
  value       = module.vpc.bastion_security_group_id
}

output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = module.vpc.rds_security_group_id
}

# Bastion EC2 Outputs
output "bastion_instance_id" {
  description = "Bastion EC2 instance ID"
  value       = module.ec2_bastion.instance_id
}

output "bastion_public_ip" {
  description = "Bastion public IP address (use to SSH)"
  value       = module.ec2_bastion.public_ip
}

output "bastion_private_ip" {
  description = "Bastion private IP address"
  value       = module.ec2_bastion.private_ip
}

# Optional App EC2 Outputs
output "app_instance_id" {
  description = "App EC2 instance ID (if deployed)"
  value       = var.deploy_app_instance ? module.ec2_app[0].instance_id : null
}

output "app_private_ip" {
  description = "App private IP address (if deployed)"
  value       = var.deploy_app_instance ? module.ec2_app[0].private_ip : null
}
