resource "aws_s3_bucket" "info_bucket" {
  bucket        = var.info_bucket_name
  force_destroy = false
}

resource "aws_s3_bucket_public_access_block" "info_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.info_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "info_bucket_encryption" {
  bucket = aws_s3_bucket.info_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "info_bucket_ownership" {
  bucket = aws_s3_bucket.info_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
