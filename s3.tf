provider "aws" {
    alias = "tokyo"
    region = "ap-northeast-1"
}

data "template_file" "bucket_policy" {
  template = "${file("${path.module}/policy.json")}"
  vars {
    bucket = "${var.aws_s3_bucket_name}"
  }
}

resource "aws_s3_bucket" "website_bucket" {
  provider = "aws.tokyo"
  bucket = "${var.aws_s3_bucket_name}"
  policy = "${data.template_file.bucket_policy.rendered}"

  website {
    index_document = "index.html"
    error_document = "404.html"
    # routing_rules = "${var.routing_rules}"
  }

  tags {
    Name = "${var.aws_s3_bucket_name}"
    Environment = "${var.aws_s3_environment}"
  }

  force_destroy=true

  # logging {
  #   target_bucket = "${var.log_bucket}"
  #   target_prefix = "${var.log_bucket_prefix}"
  # }
}