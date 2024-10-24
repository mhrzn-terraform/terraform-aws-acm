data "aws_route53_zone" "zone" {
  name         = var.hostname
  private_zone = false
}

resource "aws_acm_certificate" "wildcard_acm" {
  domain_name               = var.enable_wildcard_certificate ? "*.${var.hostname}" : var.hostname
  subject_alternative_names = var.enable_wildcard_certificate ? [var.hostname] : var.subject_alternative_names
  validation_method         = "DNS"

  tags = {
    Changed = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_route53_record" "wildcard_validation" {
  for_each = {
    for dvo in aws_acm_certificate.wildcard_acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  zone_id         = data.aws_route53_zone.zone.zone_id
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = "60"
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "wildcard_cert" {
  certificate_arn         = aws_acm_certificate.wildcard_acm.arn
  validation_record_fqdns = [for record in aws_route53_record.wildcard_validation : record.fqdn]
}

data "aws_acm_certificate" "wildcard_acm" {
  depends_on = [
    aws_acm_certificate.wildcard_acm,
    aws_route53_record.wildcard_validation,
    aws_acm_certificate_validation.wildcard_cert,
  ]

  domain      = var.enable_wildcard_certificate ? "*.${var.hostname}" : var.hostname
  statuses    = ["ISSUED"]
  most_recent = true
}
