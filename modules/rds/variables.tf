variable "allocated_storage" {
  type        = number
  description = "Allocated storage in gigabytes"
  default     = 20
}

variable "max_allocated_storage" {
  type        = number
  description = "Max storage limit for autoscaling in gigabytes"
  default     = 100
}

variable "db_name" {
  type        = string
  description = "Name of the database to create"
  default     = "hospital_cloud_backup"
}

variable "engine" {
  type        = string
  description = "Database engine"
  default     = "postgres"
}

variable "engine_version" {
  type        = string
  description = "Database engine version"
  default     = "15.4"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "username" {
  type        = string
  description = "Database administrator username"
  default     = "db_admin"
}

variable "password" {
  type        = string
  description = "Database administrator password"
  sensitive   = true
}

variable "db_subnet_group_name" {
  type        = string
  description = "DB Subnet Group name for RDS placement"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "VPC Security Group IDs to associate with RDS"
}

variable "kms_key_id" {
  type        = string
  description = "KMS Key ARN to encrypt DB storage"
}

variable "tags" {
  type        = map(string)
  default     = {}
}
