output "aws_key_pair" {
  value     = module.ec2.private_key
  sensitive = true
}

output "lb_dnsname" {
  value = module.load-balancer.alb_dns
}

output "bastion_ip" {
  value = module.ec2.bastion_ip
}