resource "aws_s3_bucket" "amdari_data_lake" {
  bucket = "data_ingestion_data_lake"

  tags = {
    Name        = "data_ingestion_data_lake"
    Environment = "Prod"
    Managed_by = "terraform"
    Team = "DE"
  }
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.amdari_data_lake.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle_config" {
  bucket = aws_s3_bucket.amdari_data_lake.id

  rule {
    id = "log"

    expiration {
      days = 90
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "GLACIER"
    }
  }
}