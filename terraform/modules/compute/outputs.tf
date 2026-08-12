output "instance_ids" {
      description = "IDs of the created EC2 instances"
      value = aws_instance.cluster[*].id
}

output "public_ips" {
  description = "Static EIPs of the EC2 instances (used for SSH access)"
  value       = aws_eip.cluster[*].public_ip
}