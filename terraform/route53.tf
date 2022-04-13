data "aws_route53_zone" "main" {
  name         = "maximilianoaguirre.com."
  private_zone = false
}

resource "aws_route53_record" "cert_validator" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  ttl     = "300"
  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
}

resource "aws_route53_record" "webpage_cloudfront_www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www.maximilianoaguirre.com"
  type    = "A"

  alias {
      name                   = aws_cloudfront_distribution.frontend_cloudfront.domain_name
      zone_id                = aws_cloudfront_distribution.frontend_cloudfront.hosted_zone_id
      evaluate_target_health = true
  }
}

resource "aws_route53_record" "webpage_cloudfront" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "maximilianoaguirre.com"
  type    = "A"

  alias {
      name                   = aws_cloudfront_distribution.frontend_cloudfront.domain_name
      zone_id                = aws_cloudfront_distribution.frontend_cloudfront.hosted_zone_id
      evaluate_target_health = true
  }
}
