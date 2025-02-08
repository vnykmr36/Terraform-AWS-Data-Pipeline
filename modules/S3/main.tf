resource "aws_s3_bucket" "s3res" {
  bucket = "<unique name here to launch bucket>" #Ex: "datalake-${var.rds_config.engine}-(var.random_text)"
  tags   = var.tags
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket                  = aws_s3_bucket.s3res.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}