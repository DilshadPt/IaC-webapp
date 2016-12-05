resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled = true
  default_root_object = "index.html"
  price_class = "PriceClass_200"
	 aliases = ["${var.pre_tag}.${var.route53_domain_name}"]
  count = "${var.cdn_boolean}"
  "origin" {

    origin_id = "origin-bucket-${aws_s3_bucket.website_bucket.id}"
    domain_name = "${aws_s3_bucket.website_bucket.website_endpoint}"
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
    default_ttl = "0" //3600
    max_ttl = "0" //86400
    target_origin_id = "origin-bucket-${aws_s3_bucket.website_bucket.id}"
    viewer_protocol_policy = "${var.protocol_policy}"
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

   "custom_error_response" {
       error_caching_min_ttl = 3000
       error_code = 403
       response_code = 200
       response_page_path = "/index.html"
   }
}

resource "aws_cloudfront_distribution" "jenkins_distribution" {
  enabled = true
  price_class = "PriceClass_200"
  aliases = ["${var.pre_tag}-jenkins.${var.route53_domain_name}"]
  count = "${var.cdn_boolean}"

  "origin" {
    origin_id = "origin-${var.dcos_public_url}"
    domain_name = "${var.dcos_public_url}"
		origin_path = "/service/jenkins-${var.pre_tag}"
		custom_origin_config {
			origin_protocol_policy = "http-only"
			http_port              = 80
			https_port             = 443
			origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1", "TLSv1"]
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
    default_ttl = "0"
    max_ttl = "0" // no caching
    target_origin_id = "origin-${var.dcos_public_url}"
    viewer_protocol_policy = "allow-all"
  }
  "restrictions" {
    "geo_restriction" {
      restriction_type = "none"
    }
  }

	"viewer_certificate" {
		cloudfront_default_certificate = true
	}

}
