resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled = true
  aliases = ["testken.uniqlo.cloud"]
  default_root_object = "index.html"

  "origin" {

    origin_id = "${var.aws_s3_bucket_name}.${aws_s3_bucket.website_bucket.website_domain}"
    domain_name = "${var.aws_s3_bucket_name}.${aws_s3_bucket.website_bucket.website_domain}"
    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port = "80"
      https_port = "443"
      origin_ssl_protocols = ["TLSv1"]
    }

  }

  "default_cache_behavior" {
    allowed_methods = ["GET", "HEAD", "DELETE", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods = ["GET", "HEAD"]
    "forwarded_values" {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    min_ttl = "0"
    default_ttl = "300" //3600
    max_ttl = "1200" //86400
    target_origin_id = "${var.aws_s3_bucket_name}.${aws_s3_bucket.website_bucket.website_domain}"
    # // This redirects any HTTP request to HTTPS. Security first!
    viewer_protocol_policy = "allow-all"
    # compress = true
  }
  "restrictions" {
    "geo_restriction" {
      restriction_type = "none"
    }
  }
   "viewer_certificate" {
     acm_certificate_arn = "${var.acm_certificate_arn}"
     ssl_support_method = "sni-only"
     minimum_protocol_version = "TLSv1"
   }


}