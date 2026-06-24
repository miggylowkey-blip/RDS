variable "subnet_id" {
  type        = string
  description = "The Subnet ID where the EC2 instance will be deployed"
}

variable "security_group_id" {
  type        = string
  description = "The Security Group ID to attach to the EC2 instance"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The hardware size of the instance"
}

variable "instance_name" {
  type        = string
  default     = "ec2-instance"
  description = "Name tag for the EC2 instance"
}

variable "associate_public_ip" {
  type        = bool
  default     = false
  description = "Whether to assign a public IP address to the EC2 instance"
}

variable "key_name" {
  type        = string
  default     = null
  description = "Optional EC2 key pair name for SSH access"
}

variable "iam_instance_profile" {
  type        = string
  default     = null
  description = "Optional IAM instance profile name for SSM or other managed access"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to attach to the EC2 instance"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC passed from the root module"
}
