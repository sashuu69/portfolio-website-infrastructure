terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "<= 5.51.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "<= 4.33.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "<= 3.4.2"
    }
  }
}

# Define aws provider
provider "aws" {
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region     = var.region
}

# Define cloudflare provider
provider "cloudflare" {
  email   = var.cloudflare_mail
  api_key = var.cloudflare_api_key
}

# Define http provider
provider "http" {}

# Define global variables
locals {
  tags = {
    Name          = var.prefix
    Maintained_By = "Terraform"
  }
  private_key_path = replace(var.public_key_path, ".pub", "")
}

# Create VPC
resource "aws_vpc" "portfolio_website_vpc" {
  cidr_block = var.vpc_cidr_block
  tags       = local.tags
}

# Create Subnet
resource "aws_subnet" "portfolio_website_subnet" {
  vpc_id                  = aws_vpc.portfolio_website_vpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags                    = local.tags
}

# Create Internet Gateway
resource "aws_internet_gateway" "portfolio_website_igw" {
  vpc_id = aws_vpc.portfolio_website_vpc.id
  tags   = local.tags
}

# Create Route Table
resource "aws_route_table" "portfolio_website_route_table" {
  vpc_id = aws_vpc.portfolio_website_vpc.id

  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = aws_internet_gateway.portfolio_website_igw.id
  }

  tags = local.tags
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "portfolio_website_subnet_association" {
  subnet_id      = aws_subnet.portfolio_website_subnet.id
  route_table_id = aws_route_table.portfolio_website_route_table.id
}

# Create Security Group
resource "aws_security_group" "portfolio_website_security_group" {
  vpc_id = aws_vpc.portfolio_website_vpc.id

  # Allow inbound traffic
  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.route_table_cidr_block]
    }
  }

  # Allow outbound traffic
  dynamic "egress" {
    for_each = var.egress_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = [var.route_table_cidr_block]
    }
  }

  tags = local.tags
}

# Allocate Elastic IP
resource "aws_eip" "portfolio_website_eip" {
  domain = "vpc"
  tags   = local.tags
}

# Create SSH Key Pair
resource "aws_key_pair" "portfolio_website_key_pair" {
  key_name   = "${var.prefix}-key"
  public_key = file(var.public_key_path)
  tags       = local.tags
}

# Associate Elastic IP with EC2 instance
resource "aws_eip_association" "portfolio_website_eip_association" {
  instance_id   = aws_instance.portfolio_website_instance.id
  allocation_id = aws_eip.portfolio_website_eip.id
}

# Create EC2 instance
resource "aws_instance" "portfolio_website_instance" {
  ami               = var.ami
  instance_type     = var.instance_type
  subnet_id         = aws_subnet.portfolio_website_subnet.id
  security_groups   = [aws_security_group.portfolio_website_security_group.id]
  availability_zone = "${var.region}a"
  key_name          = aws_key_pair.portfolio_website_key_pair.id
  tags              = local.tags
}

locals {
  dns_records = [
    {
      name  = var.portfolio_website_domain_name
      value = aws_eip_association.portfolio_website_eip_association.public_ip
      type  = "A"
    },
    {
      name  = "www.${var.portfolio_website_domain_name}"
      value = var.portfolio_website_domain_name
      type  = "CNAME"
    }
  ]
}

# Set Cloudflare DNS records
resource "cloudflare_record" "portfolio_website_dns_records" {
  for_each = { for record in local.dns_records : record.name => record }

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  value   = each.value.value
  type    = each.value.type

  depends_on = [aws_instance.portfolio_website_instance]
}

# Create inventory file
resource "local_file" "portfolio_website_inventory_file" {
  content  = <<EOF
[aws]
${aws_eip_association.portfolio_website_eip_association.public_ip} ansible_user=${var.instance_username} ansible_ssh_private_key_file=${local.private_key_path} ansible_ssh_common_args='-o StrictHostKeyChecking=no' portfolio_website_git_repo=${var.portfolio_website_git_repository} portfolio_website_dc_git_repo=${var.dc_github_repository} username=${var.instance_username} certificate_path=${var.ssl_certificate_path} ubuntu_version=${var.ubuntu_version_codename} domain_name=${var.portfolio_website_domain_name}
  EOF
  filename = var.inventory_path
}

# Run ansible playbook
resource "null_resource" "portfolio_website_ansible_playbook" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOT
    sleep 30
    ansible-playbook -i ${var.inventory_path} playbook.yaml
    EOT
  }

  depends_on = [
    aws_instance.portfolio_website_instance,
    local_file.portfolio_website_inventory_file
  ]
}

# Wait for Portfolio Website to come up
resource "null_resource" "portfolio_website_wait" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "sleep 60"
  }
}
