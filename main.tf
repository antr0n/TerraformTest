# Create an S3 bucket
resource "aws_s3_bucket" "hostbucket" {
  bucket = var.bucket_name
}

# Bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "hostbucket" {
  bucket = aws_s3_bucket.hostbucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Public access block
resource "aws_s3_bucket_public_access_block" "hostbucket" {
  bucket = aws_s3_bucket.hostbucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 bucket ACL
resource "aws_s3_bucket_acl" "hostbucket" {
  depends_on = [ 
    aws_s3_bucket_ownership_controls.hostbucket,
    aws_s3_bucket_public_access_block.hostbucket,
   ]

  bucket = aws_s3_bucket.hostbucket.id
  acl    = "public-read"
}

# S3 website configuration
resource "aws_s3_bucket_website_configuration" "hostbucket" {
  bucket = aws_s3_bucket.hostbucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.hostbucket ]
}

# S3 bucket policy to allow public read access
resource "aws_s3_bucket_policy" "hostbucket" {
  bucket = aws_s3_bucket.hostbucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.hostbucket.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.hostbucket]
}

# Website index object
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.hostbucket.id
  key          = "index.html"
  source       = "site/index.html"
  content_type = "text/html"
}

# Website error object
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.hostbucket.id
  key          = "error.html"
  source       = "site/error.html"
  content_type = "text/html"
}

# Website image object
resource "aws_s3_object" "image" {
  bucket       = aws_s3_bucket.hostbucket.id
  key          = "otters.png"
  source       = "site/otters.png"
  content_type = "image/png"
}