output "public_ip" {
  value       = aws_instance.database.public_ip
  description = "The public IP address of the EC2 instance"
}

output "instance_id" {
  value       = aws_instance.database.id
  description = "The EC2 instance ID"
}

output "private_ip" {
  value       = aws_instance.database.private_ip
  description = "The private IP address of the EC2 instance"
}
