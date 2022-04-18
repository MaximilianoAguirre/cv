resource "aws_cloudfront_distribution" "frontend_cloudfront_static" {
  origin {
    domain_name = aws_s3_bucket.static_cv.bucket_regional_domain_name
    origin_id   = "frontendBucket"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Maximiliano Aguirre CV"
  default_root_object = "index.html"
  aliases             = ["maximilianoaguirre.com", "www.maximilianoaguirre.com"]

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.cert.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "frontendBucket"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "404"
    response_code         = "200"
    response_page_path    = "/index.html"
  }

  price_class = "PriceClass_100"
}

resource "aws_cloudfront_distribution" "frontend_cloudfront_bash" {
  origin {
    domain_name = aws_s3_bucket.bash_cv.bucket_regional_domain_name
    origin_id   = "frontendBucket"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Maximiliano Aguirre bash CV"
  default_root_object = "index.html"
  aliases             = ["bash.maximilianoaguirre.com"]

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.cert.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "frontendBucket"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "404"
    response_code         = "200"
    response_page_path    = "/index.html"
  }

  price_class = "PriceClass_100"
}