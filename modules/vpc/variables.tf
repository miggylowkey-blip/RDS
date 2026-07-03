variable "client_name" {
  type        = string
  description = "The name of the client for tagging resource names"
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g., production, staging)"
}

variable "vpc_cidr" {
  type        = string
  description = "The master CIDR block for the entire VPC network"
}

variable "availability_zones" {
  type        = list(string)
  description = "The AWS availability zones where subnets will be allocated"
}

variable "enable_nat" {
  type        = bool
  description = "Whether to create a NAT gateway for private subnet internet access (costly)."
  default     = true
}

variable "trusted_ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH to bastion (set to your office IP). Use carefully."
  default     = "0.0.0.0/0"
}

variable "db_port" {
  type        = number
  description = "Database engine port (e.g. 5432 for Postgres)."
  default     = 5432
}

variable "allow_public_http" {
  type        = bool
  description = "Whether to add an example public HTTP rule for app SG (not recommended for production)."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to created resources"
  default     = {}
}