resource "tls_private_key" "aoa-demo-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.ec2_instance_name}_key_pair"
  public_key = tls_private_key.aoa-demo-key.public_key_openssh
}

resource "aws_instance" "bastion" {
  ami                         = "ami-0666c668000b91fcb"
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated_key.key_name
  vpc_security_group_ids      = [var.ec2_security_group_id]
  subnet_id                   = var.public_subnet_az1_id
  tags = {
    Name = "Bastion"
  }
}


resource "aws_launch_configuration" "ec2" {
  name                        = "${var.ec2_instance_name}-instances"
  image_id                    = "ami-0666c668000b91fcb"
  instance_type               = var.instance_type
  security_groups             = [var.ec2_security_group_id]
  associate_public_ip_address = false
  user_data                   = filebase64("./modules/ec2/nginx-script.sh")
  depends_on                  = [var.nat_gateway_az1]
  key_name                    = aws_key_pair.generated_key.key_name

}

resource "aws_autoscaling_group" "ec2-cluster" {
  name                 = "${var.ec2_instance_name}_auto_scaling_group"
  min_size             = var.autoscale_min
  max_size             = var.autoscale_max
  desired_capacity     = var.autoscale_desired
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.ec2.name
  vpc_zone_identifier  = [var.private_subnet_az1_id, var.private_subnet_az2_id]
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.ec2-cluster.id
  lb_target_group_arn    = var.alb_tg
}