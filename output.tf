output "private_key" {
  description = "Private key path"
  value = local.private_key_path
}

output "public_ip" {
  description = "Public IP of created instance"
  value       = aws_eip_association.portfolio_website_eip_association.public_ip
}

output "ssh-command" {
  description = "SSH command to connect to created EC2 instance"
  value       = "ssh -i ${local.private_key_path} ${var.instance_username}@${aws_eip_association.portfolio_website_eip_association.public_ip}"
}
