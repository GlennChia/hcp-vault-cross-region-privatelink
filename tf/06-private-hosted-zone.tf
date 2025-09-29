resource "aws_route53_zone" "private" {
  name = "hashicorp.cloud"

  vpc {
    vpc_id = aws_vpc.ec2_client.id
  }
}

resource "aws_route53_record" "private_zone_hvd_dns_entry" {
  name    = local.vault_private_endpoint_host
  zone_id = aws_route53_zone.private.zone_id
  type    = "CNAME"
  ttl     = 300
  records = [aws_vpc_endpoint.vault_hvd.dns_entry[0].dns_name]
}
