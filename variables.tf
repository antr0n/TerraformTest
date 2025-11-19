variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "terraform-test-bucket-11-18-2025"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}
