output "public_ip" {
  description = "Public IP of created instance"
  value       = aws_eip_association.portfolio_website_eip_association.public_ip
}

output "ssh-command" {
  description = "SSH command to connect to created EC2 instance"
  value       = "ssh -i ${replace(var.public_key_path, ".pub", "")} ubuntu@${aws_eip_association.portfolio_website_eip_association.public_ip}"
}