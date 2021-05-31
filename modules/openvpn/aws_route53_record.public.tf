# ROUTE53 PUBLIC DNS
resource "aws_route53_record" "public" {
  zone_id = var.openvpn_route53_public_zone_id
  name    = var.openvpn_public_dns
  type    = "A"
  ttl     = "300"
  records = ["${local.public_ip}"]
}
