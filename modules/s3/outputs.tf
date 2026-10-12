output "bucket_name" {
  value = aws_s3_bucket.airflow.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.airflow.arn
}

output "bucket_region" {
  value = aws_s3_bucket.airflow.region
}
