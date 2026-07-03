output "vpc_id" {
    description = "The ID of this vpc"
    value = aws_vpc.this.id
}


output "subnet_ids" {
  description = "Lists of all types of subnet IDs"
  value       = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "subnet_id" {
  description = "A public subnet ID for compute and LB placement"
  value       = aws_subnet.public[0].id
}

output "rds_security_group_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.rds_security_group.id
}

output "app_security_group_id" {
  description = "The ID of the application security group"
  value       = aws_security_group.app_sg.id
}

output "bastion_security_group_id" {
  description = "The ID of the bastion security group"
  value       = aws_security_group.bastion_sg.id
}

output "db_subnet_group" {
  description = "The DB subnet group name for RDS"
  value       = aws_db_subnet_group.this.name
}

output "private_subnet_availability_zones" {
  description = "List of Availability zones for private subnets"
  value       = aws_subnet.private[*].availability_zone 
}

output "public_subnet_availability_zones" {
  description = "List of Availability zones for public subnets"
  value       = aws_subnet.public[*].availability_zone 
}

output "private_route_table_id" {
  description = "Private route table ID"
  value       = aws_route_table.private.id
}

output "public_route_table_id" {
  description = "Public route table ID"
  value       = aws_route_table.public.id
}

