# Overview
This project demonstrates a simple NGINX web application using Terraform and GitHub Actions. The application shows the hostname of the instance that handled the request. Here are the key components:

- **VPC Setup**: 
    - The project creates a Virtual Private Cloud (VPC) with:
        - Two public subnets and two private subnets in different availability zones for high availability.
        - An Internet Gateway to manage internet traffic.
        - A NAT Gateway to enable private subnets to connect to the internet.
- **EC2 Instances Management**:
    - Utilizes Autoscaling groups and launch templates for managing EC2 instances.
    - Implements security groups and route tables to facilitate traffic flow between subnets, NAT, and Internet Gateways.
- **Load Balancing**:
    - Incorporates an Application Load Balancer to distribute traffic among EC2 instances in the Autoscaling group.
- **Bastion Host**:
    - Includes a Bastion EC2 instance to allow SSH access into the EC2 instances located in private subnets.

Overall, this setup ensures a secure and scalable web application infrastructure with high availability, effective traffic management, and the ability to securely access instances using a Bastion host.

<img width="884" alt="aoa-demo-architectiure" src="https://github.com/alionur07/webapp-infrastructure-demo/assets/33215825/c62e8a45-acef-4301-a928-e705ad4b57a0">


```demo-aoa-project/
├── main.tf
├── variables.tf
├── backend.tf
├── modules/
│   │
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
|   |
│   ├── security-groups/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   |
|   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── load_balancer/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
└── outputs.tf
```

- main.tf: The main Terraform configuration file that references the modules.
- variables.tf: Top-level variables that are used across different modules.
- backend.tf: Manages terraform state.
- modules/:
    - vpc/: Manages the VPC configuration.
    - security-groups/: Manages security group configurations
    - ec2/: Manages the EC2 instances, launch configurations and the Auto Scaling configuration.
    - load_balancer/: Manages the Application Load Balancer configuration.
- outputs.tf: Defines the outputs that you want to expose after applying the Terraform configuration.

# Prerequisites
Before running the demo NGINX application, ensure that you have the following dependencies installed:

**Terraform backend** 
- Create an S3 bucket and allow public access.
- Create DynamoDB.
- Create a role ARN and attach the admin policy.

**Github Env variable** 
- Create AWS access and secret keys and set them as secret environment variables in GitHub.

# Usage

To test whether the NGINX welcome page is working, retrieve the external IP information from the output of the Terraform Apply step in the pipeline. All steps are triggered automatically after the changes are pushed to the master branch.

<img width="1635" alt="image" src="https://github.com/alionur07/demo-aoa/assets/33215825/faeb93fd-de28-4ce1-a423-d9b4b4f8cd03">
<img width="933" alt="image" src="https://github.com/alionur07/demo-aoa/assets/33215825/29cb6259-73e5-4999-b027-68e970cc7302">
<img width="1077" alt="image" src="https://github.com/alionur07/demo-aoa/assets/33215825/03190d30-724e-4510-ac78-9931cd130c93">

To destroy the resources, simply respond "yes" to the issue created for the Terraform Destroy step.
<img width="1061" alt="image" src="https://github.com/alionur07/demo-aoa/assets/33215825/1ab231c5-b7e4-4e23-b76a-acb51285be33">
<img width="1012" alt="image" src="https://github.com/alionur07/demo-aoa/assets/33215825/2f81c4ea-5700-4d11-9da6-e7578102befb">


