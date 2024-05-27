variable "prefix" {
  description = "The prefix for name of created resource"
  type        = string
  default     = "portfolio-website"
}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
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
  default     = "~/Keys/AWS/flsashwat/id_rsa.pub"
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

variable "instance_type" {
  description = "The instance type to use for the instance"
  type        = string
  default     = "t2.micro"
}
