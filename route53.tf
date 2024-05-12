resource "aws_route53_record" "www" {
  zone_id = "Z08990232N81R0KC6694K" - we can create variabels to use host zone id  # Specify the Route 53 hosted zone ID where you want to create the record
  name    = "juliamashkova.link" - we need to change to Nodar name  # Specify the domain name you want to associate with the ALB
  type    = "A"
  alias {
    name                   = aws_lb.wordpress_alb.dns_name  # Specify the DNS name of your ALB
    zone_id                = aws_lb.wordpress_alb.zone_id
    # Specify the Route 53 hosted zone ID where you want to create the record
# "  # Specify the hosted zone ID of your ALB
    evaluate_target_health = true
  }
}
