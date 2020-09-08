output "iam_role_arn" {
  value = aws_iam_role.kentik_role.arn
}

output "bucket_name" {
  value = aws_s3_bucket.vpc_logs.bucket
}
