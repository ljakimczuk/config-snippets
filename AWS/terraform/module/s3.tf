resource "aws_s3_bucket" "vpc_logs" {
  bucket = join("-",[var.s3_bucket_prefix,var.vpc_id,"flow-logs"])
  acl = "private"
}

resource "aws_s3_bucket_public_access_block" "vpc_logs" {
  bucket = aws_s3_bucket.vpc_logs.id
  block_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls = true
}

resource "aws_flow_log" "vpc_logs" {
  log_destination = aws_s3_bucket.vpc_logs.arn
  log_destination_type = "s3"
  traffic_type = "ALL"
  vpc_id = var.vpc_id
}
