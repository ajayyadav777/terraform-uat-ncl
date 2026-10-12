resource "aws_s3_bucket" "airflow" {
  bucket = "${local.name_prefix}-airflow"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-airflow"
    }
  )
}

resource "aws_s3_bucket_versioning" "airflow" {
  bucket = aws_s3_bucket.airflow.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "airflow" {
  bucket = aws_s3_bucket.airflow.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "airflow" {
  bucket = aws_s3_bucket.airflow.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
