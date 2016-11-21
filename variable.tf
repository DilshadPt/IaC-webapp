variable "aws_s3_bucket_name" {
  description = "Name of the aws s3 bucket to which builded codes are deployed"
}

variable "aws_s3_environment" {
  description = "Name of the aws s3 bucket environment"
}

variable "region" {
  description = "Name of the aws s3 bucket region"
}

variable "acm_certificate_arn" {
  description = "value of the aws certificate arn"
}