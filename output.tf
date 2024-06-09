output "ssh-command" {
  description = "SSH command to connect to created EC2 instance"
  value       = "ssh -i ${local.private_key_path} ${var.instance_username}@${aws_eip_association.portfolio_website_eip_association.public_ip}"
}
