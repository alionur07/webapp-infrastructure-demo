output "app_asg" {
  value = aws_autoscaling_group.ec2-cluster.id
}

output "private_key" {
  value     = tls_private_key.aoa-demo-key.private_key_pem
  sensitive = true
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}