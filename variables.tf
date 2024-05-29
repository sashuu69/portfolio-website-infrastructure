variable "prefix" {
  description = "The prefix for name of created resource"
  type        = string
  default     = "portfolio-website"
}

variable "aws_access_key_id" {
  description = "The AWS access key ID"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "The AWS secret access key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

variable "cloudflare_mail" {
  description = "The cloudflare mail ID"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_key" {
  description = "The cloudflare API key"
  type        = string
  sensitive   = true
}

variable "vpc_cidr_block" {
  description = "The CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "The CIDR block for Subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "route_table_cidr_block" {
  description = "The CIDR block for route table"
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_key_path" {
  description = "Public key to add to instance for SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ingress_ports" {
  description = "list of ingress ports for security group"
  type        = list(any)
  default     = [22, 80, 443]
}

variable "egress_ports" {
  description = "list of egress ports for security group"
  type        = list(any)
  default     = [0]
}

variable "ami" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = "ami-0f58b397bc5c1f2e8" # Ubuntu Server 24.04
}

variable "ubuntu_version_codename" {
  description = "Ubuntu version code name (eg: noble)"
  type        = string
  default     = "noble"
}

variable "instance_type" {
  description = "The instance type to use for the instance"
  type        = string
  default     = "t2.micro"
}

variable "portfolio_website_git_repository" {
  description = "The GitHub repository path of portfolio website"
  type = string
  default = "https://github.com/sashuu69/portfolio-website"
}

variable "dc_github_repository" {
  description = "The GitHub repository path of portfolio website Docker Compose"
  type        = string
  default     = "https://github.com/sashuu69/portfolio-website-docker-compose"
}

variable "ssl_certificate_path" {
  description = "The SSL certificate path for HTTPS"
  type        = string
}

variable "instance_username" {
  description = "The username for the instance"
  type        = string
  default     = "ubuntu"
}

variable "inventory_path" {
  description = "The ansible playbook inventory path"
  type        = string
  default     = "build/inventory.ini"
}

variable "cloudflare_zone_id" {
  description = "The cloudflare Zone ID"
  type        = string
  sensitive   = true
}

variable "portfolio_website_domain_name" {
  description = "The Domain name for portfolio website"
  type        = string
}