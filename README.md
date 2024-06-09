# Portfolio Website Infrastructure

## Status

![Website Status](https://img.shields.io/website?url=https%3A%2F%2Fsashwat.in)
[![Ansible Lint CI](https://github.com/sashuu69/portfolio-website-infrastructure/actions/workflows/ansible-lint.yaml/badge.svg)](https://github.com/sashuu69/portfolio-website-infrastructure/actions/workflows/ansible-lint.yaml)
[![Terraform Validate CI](https://github.com/sashuu69/portfolio-website-infrastructure/actions/workflows/terraform-validate.yml/badge.svg)](https://github.com/sashuu69/portfolio-website-infrastructure/actions/workflows/terraform-validate.yml)

## Introduction

The repository contains code to bring up the portfolio website. The website is brought up on AWS using Terraform and configured using Ansible.

The Terraform code brings up VPC, subnet, gateway, route table, security group, floating IP and EC2 instance. After the instance is brought up, ansible brings up the application.

## Instructions

1. Make sure terraform and ansible is installed in the host.
2. Copy contents of `env.template` to `env`.
   
    ```bash
    cp env.template env
    ```
3. Update `env` to appropriate values. The following is an example.

    ```bash
    sashuu69@Sashwats-MacBook-Pro portfolio-website-infrastructure % cat env
    export PW_PREFIX="portfolio-website"
    export PW_AWS_ACCESS_KEY_ID="<AWS-ACCESS-KEY-ID>"
    export PW_AWS_SECRET_ACCESS_KEY="<AWS-SECRET-ACCESS-KEY>"
    export PW_AWS_REGION="ap-south-1"
    export PW_CLOUDFLARE_MAIL="<CLOUDFLARE-MAIL-ID>"
    export PW_CLOUDFLARE_API_KEY="<CLOUDFLARE-API-KEY>"
    export PW_AWS_VPC_CIDR_BLOCK="10.0.0.0/16"
    export PW_AWS_SUBNET_CIDR_BLOCK="10.0.1.0/24"
    export PW_AWS_ROUTE_CIDR_BLOCK="0.0.0.0/0"
    export PW_AWS_PUBLIC_KEY_PATH="build/ssh/id_rsa.pub"
    export PW_AWS_INGRESS_PORTS="[22,80,443]"
    export PW_AWS_EGRESS_PORTS="[0]"
    export PW_AWS_AMI="ami-0f58b397bc5c1f2e8"
    export PW_UBUNTU_VERSION_CODENAME="noble"
    export PW_INSTANCE_TYPE="t2.micro"
    export PW_GITHUB_REPOSITORY="https://github.com/sashuu69/portfolio-website"
    export PW_DC_GITHUB_REPOSITORY="https://github.com/sashuu69/portfolio-website-docker-compose"
    export PW_SSL_CERTIFICATE_PATH="build/certs"
    export PW_INSTANCE_USERNAME="ubuntu"
    export PW_ANSIBLE_INVENTORY_PATH="build/inventory.ini"
    export PW_CLOUDFLARE_ZONE_ID="<CLOUDFLARE-ZONE-ID>"
    export PW_DOMAIN_NAME="<DOMAIN>"
    sashuu69@Sashwats-MacBook-Pro portfolio-website-infrastructure % 
    ```
4. Source the newly created `env` file.
    ```bash
    source env
    ```
5. Run `./run.sh apply` to bring up the portfolio website.
6. (Optional) Run `./run.sh destroy` to bring down the portfolio website.

## Contributors

1. Sashwat K <sashwat0001@gmail.com>

## Other Info

If you face any bugs or want to request a new feature, please create an issue under the repository and provide appropriate labels respectively. If you want to do these by yourself, feel free to raise a PR and I will do what is necessary.

If you want to support me, donations will be helpful.

## Other Repo(s)

1. [sashuu69/portfolio-website](https://github.com/sashuu69/portfolio-website) - The portfolio website flask app
2. [sashuu69/portfolio-website-docker-compose](https://github.com/sashuu69/portfolio-website-docker-compose) - The docker-compose code to bring up portfolio website
3. [sashuu69/portfolio-website-ssl-cert-generator](https://github.com/sashuu69/portfolio-website-ssl-cert-generator) - The terraform code to generate/renew SSL certificates
