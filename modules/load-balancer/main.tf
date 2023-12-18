# Load Balancer
resource "aws_lb" "alb" {
  name               = "${var.ec2_instance_name}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [var.alb_security_group_id]
  subnets            = [var.public_subnet_az1_id, var.public_subnet_az2_id]
}

# Target group
resource "aws_alb_target_group" "alb-target-group" {
  name     = "${var.ec2_instance_name}-tg"
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = var.health_check_path
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 60
    matcher             = "200"
  }
}


resource "aws_alb_listener" "ec2-alb-http-listener" {
  load_balancer_arn = aws_lb.alb.id
  port              = var.listener_port
  protocol          = var.listener_protocol
  depends_on        = [aws_alb_target_group.alb-target-group]

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb-target-group.arn
  }
}