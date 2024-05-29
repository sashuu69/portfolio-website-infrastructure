# Portfolio Website Infrastructure

## Status

![Website Status](https://img.shields.io/website?url=https%3A%2F%2Fsashwat.in)

## Introduction

The repository contains code to bring up the portfolio website. The website is brought up on AWS using Terraform and configured using Ansible.

The Terraform code brings up VPC, subnet, gateway, route table, security group, floating IP and EC2 instance. After the instance is brought up, ansible brings up the application.

## Instructions

1. Copy contents of `my-settings.auto.tfvars-template` to `my-settings.auto.tfvars`.
    ```bash
    cp my-settings.auto.tfvars-template my-settings.auto.tfvars
    ```
2. Update my-settings.auto.tfvars to appropriate values.
3. Initiaze terraform.
    ```bash
    terraform init
    ```
4. Deploy the application.
    ```bash
    terraform apply --auto-approve
    ```
5. (Optional) To bring down the application.
    ```bash
    terraform destroy --auto-approve
    ```

## Contributors

1. Sashwat K <sashwat0001@gmail.com>

## Other Info

If you face any bugs or want to request for a new feature, please create an issue under the repository and provide appropriate labels respectively. If you want to do these by yourself, feel free to raise a PR and I will do the necessary.

If you want to support me, donations will be helpful.
