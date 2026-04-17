# 기존 도메인 호스팅 영역 정보 가져오기
data "aws_route53_zone" "selected" {
  name = var.domain_name
}

# 1. 도메인 A 레코드 (taebin.shop을 ALB로 연결)
resource "aws_route53_record" "alb_alias" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.diary_alb.dns_name
    zone_id                = aws_lb.diary_alb.zone_id
    evaluate_target_health = true
  }
}

# 2. www 도메인 A 레코드 (www.taebin.shop도 ALB로 연결)
resource "aws_route53_record" "www_alb_alias" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.diary_alb.dns_name
    zone_id                = aws_lb.diary_alb.zone_id
    evaluate_target_health = true
  }
}