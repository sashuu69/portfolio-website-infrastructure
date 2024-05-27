terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "<= 5.51.1"
    }
  }
}

# Define provider
provider "aws" {
  region = var.region
}

# Define global variables
locals {
  tags = {
    Name          = var.prefix
    Maintained_By = "Terraform"
  }
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

# Wait until the instance is in 'running' state
resource "null_resource" "wait_for_instance" {
  provisioner "local-exec" {
    command = <<EOT
      instance_id=${aws_instance.portfolio_website_instance.id}
      while true; do
        status=$(aws ec2 describe-instances --instance-id $instance_id --query "Reservations[0].Instances[0].State.Name" --output text)
        if [ "$status" == "running" ]; then
          echo "Instance is running."
          exit 0
        elif [ "$status" == "shutting-down" ] || [ "$status" == "terminated" ] || [ "$status" == "stopping" ] || [ "$status" == "stopped" ]; then
          echo "Instance is in an unexpected state: $status"
          exit 1
        else
          echo "Current status: $status. Waiting for instance to be running..."
          sleep 10
        fi
      done
    EOT
  }

  depends_on = [aws_instance.portfolio_website_instance]
}