output "private_key" {
  description = "Private key path"
  value = replace(var.public_key_path, ".pub", "")
}

output "user" {
  description = "Username of EC2 instance"
  value = "ubuntu"
}

output "public_ip" {
  description = "Public IP of created instance"
  value       = aws_eip_association.portfolio_website_eip_association.public_ip
}

output "ssh-command" {
  description = "SSH command to connect to created EC2 instance"
  value       = "ssh -i ${private_key} ${user}@${public_ip}"
}
