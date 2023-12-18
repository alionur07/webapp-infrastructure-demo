variable "public_subnet_az1_id" {}
variable "private_subnet_az1_id" {}
variable "private_subnet_az2_id" {}
variable "ec2_security_group_id" {}
variable "ec2_instance_name" {}
variable "region" {}
variable "nat_gateway_az1" {
  
}
variable "instance_type" {
  default = "t2.micro"
}

variable "autoscale_min" {
  description = "Minimum autoscale (number of EC2)"
  default     = "2"
}
variable "autoscale_max" {
  description = "Maximum autoscale (number of EC2)"
  default     = "4"
}
variable "autoscale_desired" {
  description = "Desired autoscale (number of EC2)"
  default     = "2"
}
variable "alb_tg" {}
variable "ssh_pubkey_file" {
  description = "Path to an SSH public key"
  default     = "./modules/ec2/aws_key.pub"
}