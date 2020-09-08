variable "rw_s3_access" {
  description = "If set to true, Kentik platform will be able to delete old logs from s3 bucket"
  type        = bool
}

variable "vpc_id" {
  description = "List of VPC ids for which Kentik should gather logs"
  type        = string
}

variable "region" {
  description = "Region to use"
  type        = string
}

variable "s3_bucket_prefix" {
  description = "Prefix to use with s3 bucket name"
  type        = string
  default     = "kentik"
}
