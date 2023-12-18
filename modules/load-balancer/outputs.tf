output "alb" {
  value = aws_lb.alb.id
}

output "alb_tg" {
  value = aws_alb_target_group.alb-target-group.arn
}

output "alb_dns" {
  value = aws_lb.alb.dns_name
}