variable "public_subnet_az1_id" {}
variable "public_subnet_az2_id" {}
variable "vpc_id" {}
variable "alb_security_group_id" {}
variable "ec2_instance_name" {}
variable "tg_protocol" {
  default = "HTTP"
}

variable "tg_port" {
  default = 80
}

variable "listener_protocol" {
  default = "HTTP"
}

variable "listener_port" {
  default = 80
}
variable "health_check_path" {
  description = "Health check path for the default target group"
  default     = "/"
}