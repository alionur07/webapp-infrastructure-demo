variable "region" {
  description = "AWS region."
  default     = "eu-west-1"
}
variable "project_name" {
  default     = "aoa-demo"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "public_subnet_az1_cidr" {
  default = "10.0.1.0/24"
}
variable "public_subnet_az2_cidr" {
  default = "10.0.2.0/24"
}
variable "private_subnet_az1_cidr" {
  default = "10.0.3.0/24"
}
variable "private_subnet_az2_cidr" {
  default = "10.0.4.0/24"
}

variable "ec2_instance_name" {
  default     = "aoa-demo"
}