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
Before running the pipeline, ensure that you have the following dependencies installed:

**Github Env variable** 
- Create AWS access and secret keys and set them as secret environment variables in GitHub.
- Check the pipeline env and replace it with the necessary information 

**Terraform backend** 
- S3 bucket and Dynamodb are automatically created in the pipeline

## Requirements
| Name             | Version    | 
| :----------------| :----------|
| `terraform`      | `>= 0.13.1`|
| `aws-actions`    | `>=v1`     |
| `manual-approval`| `>=v1`     |

## Providers

| Name         | Version    | 
| :------------| :----------|
| `terraform`  | `>= 0.13.1`|
| `aws`        | `=5.31.0`  |
| `tls`        | `>= 4.0`   |
  
# Usage

To test whether the NGINX web page is working, retrieve the loadbalancer dns name from the output of the Terraform Apply step in the pipeline. Also bastion host ip address and generated aws_key_pair.pem information provided by the terraform output.
All steps are triggered automatically after the changes are pushed to the master branch.



To destroy the resources, simply respond "yes" to the issue created for the Terraform Destroy step.


# Troubleshoot
If an error is received in the approval step please select read and write permission in repo-settings/Actions/General/WorkflowPermissions 

```
Respond "approved", "approve", "lgtm", "yes" to continue workflow or "denied", "deny", "no" to cancel.
error creating issue: POST https://api.github.com/repos/alionur07/webapp-infrastructure-demo/issues: 403 Resource not accessible by integration []
```


