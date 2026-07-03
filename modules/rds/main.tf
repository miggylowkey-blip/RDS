resource "aws_db_instance" "this" {
  identifier            = "hospital-rds-backup"
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  db_name               = var.db_name
  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  
  username             = var.username
  password             = var.password
  db_subnet_group_name = var.db_subnet_group_name
  
  vpc_security_group_ids = var.vpc_security_group_ids
  
  # Encryption at rest
  storage_encrypted = true
  kms_key_id        = var.kms_key_id

  # Backup & maintenance
  backup_retention_period = 7
  skip_final_snapshot     = true # Set to false in production

  tags = var.tags
}
