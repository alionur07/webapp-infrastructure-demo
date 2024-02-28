# Use a base image with common tools
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive
# Install basic dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    unzip \
    software-properties-common \
    gnupg \
    python3 \
    default-jre \
    openssh-server \
    ansible \
    postgresql \
    mysql-client \
    nginx 

# Install Docker
RUN apt-get install -y ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && chmod a+r /etc/apt/keyrings/docker.asc &&\
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# Install eksctl
RUN curl -LO https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz && \
    tar xzvf eksctl_Linux_amd64.tar.gz && \
    mv eksctl /usr/local/bin/eksctl

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/1.0.4/terraform_1.0.4_linux_amd64.zip && \
    unzip terraform_1.0.4_linux_amd64.zip && \
    mv terraform /usr/local/bin/terraform && \
    rm terraform_1.0.4_linux_amd64.zip

# Install Terragrunt
RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.40.0/terragrunt_linux_amd64 && \
    chmod +x terragrunt_linux_amd64 && \
    mv terragrunt_linux_amd64 /usr/local/bin/terragrunt

# Install YAML tools (yq)
RUN wget https://github.com/mikefarah/yq/releases/download/v4.12.2/yq_linux_amd64 -O /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

# Install Helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null && \
    apt-get install -y apt-transport-https --yes && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update && apt-get install -y  helm


# Expose SSH port
EXPOSE 80

# Start SSH server
CMD ["nginx", "-g", "daemon off;"]
