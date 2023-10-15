resource "aws_s3_bucket" "tfa-hc-s3-public-write-allowed-fa2il-bf6" {
  bucket = "tfa-hc-s3-public-write-allowed-fa2il"
  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }
  object_lock_enabled = true
  tags = {
    Owner = "Tahash"
  }
}

