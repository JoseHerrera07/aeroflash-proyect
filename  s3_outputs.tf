# s3_outputs.tf
# Outputs relacionados con S3

output "s3_bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.main.id
}

output "s3_bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.main.arn
}

output "s3_bucket_regional_domain_name" {
  description = "Nombre de dominio regional del bucket S3"
  value       = aws_s3_bucket.main.bucket_regional_domain_name
}

output "s3_website_endpoint" {
  description = "Endpoint del sitio web estático en S3"
  value       = aws_s3_bucket_website_configuration.main.website_endpoint
}

output "s3_website_url" {
  description = "URL completa del sitio web estático"
  value       = "http://${aws_s3_bucket_website_configuration.main.website_endpoint}"
}

output "s3_bucket_region" {
  description = "Región donde se encuentra el bucket S3"
  value       = aws_s3_bucket.main.region
}
