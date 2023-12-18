
#create vpc

module "vpc" {
    source                           = "./modules/vpc"
    region                           = var.region
    project_name                     = var.project_name
    vpc_cidr                         = var.vpc_cidr
    public_subnet_az1_cidr           = var.public_subnet_az1_cidr
    public_subnet_az2_cidr           = var.public_subnet_az2_cidr
    private_subnet_az1_cidr          = var.private_subnet_az1_cidr
    private_subnet_az2_cidr          = var.private_subnet_az2_cidr
    }

 #create security groups
 
 module "security-groups" {
    source                         = "./modules/security-groups"
    vpc_id                         = module.vpc.vpc_id
     
 }
 
 #create EC2 instances
 
  module "ec2" {
    source                         = "./modules/ec2"
    region                         = var.region
    ec2_instance_name              = var.ec2_instance_name
    ec2_security_group_id          = module.security-groups.ec2_security_group_id
    public_subnet_az1_id           = module.vpc.public_subnet_az1_id  
    nat_gateway_az1                = module.vpc.nat_gateway_az1
    private_subnet_az1_id          = module.vpc.private_subnet_az1_id
    private_subnet_az2_id          = module.vpc.private_subnet_az2_id
    alb_tg                         = module.load-balancer.alb_tg
}   
     
 #create load balancer
    
module "load-balancer" {
    source                         = "./modules/load-balancer"
    ec2_instance_name              = var.ec2_instance_name
    vpc_id                         = module.vpc.vpc_id
    public_subnet_az1_id           = module.vpc.public_subnet_az1_id
    public_subnet_az2_id           = module.vpc.public_subnet_az2_id
    alb_security_group_id          = module.security-groups.alb_security_group_id
}
