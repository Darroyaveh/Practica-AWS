output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances."
  value       = module.ec2_instances.public_ip_addresses
}

output "instance_ids" {
  description = "IDs of the EC2 instances."
  value       = module.ec2_instances.instance_ids
}

output "instance_private_ips" {
  description = "Private IP addresses of the EC2 instances."
  value       = module.ec2_instances.private_ip_addresses
}

output "security_group_id" {
  description = "ID of the security group created."
  value       = aws_security_group.instance_sg.id
}
