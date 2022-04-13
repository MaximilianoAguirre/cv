resource "aws_acm_certificate" "cert" {
  domain_name       = data.aws_route53_zone.main.name
  validation_method = "DNS"

  subject_alternative_names = ["*.${data.aws_route53_zone.main.name}"]

  lifecycle {
    create_before_destroy = true
  }
}
