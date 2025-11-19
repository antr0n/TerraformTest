output "website_endpoint" {
  value       = aws_s3_bucket_website_configuration.hostbucket.website_endpoint
  description = "The website endpoint URL"
}

output "bucket_name" {
  value       = aws_s3_bucket.hostbucket.id
  description = "The name of the S3 bucket"
}