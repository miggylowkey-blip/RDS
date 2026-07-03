# KMS Keys for hospital hybrid cloud infrastructure encryption

resource "aws_kms_key" "hospital_kms" {
  description             = "KMS Key for hospital cloud storage and database encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name      = "${var.client_name}-${var.environment}-kms"
    ManagedBy = "Terraform"
  }
}

resource "aws_kms_alias" "hospital_kms_alias" {
  name          = "alias/hospital-kms-${var.environment}"
  target_key_id = aws_kms_key.hospital_kms.key_id
}
