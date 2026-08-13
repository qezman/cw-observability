output "vpc_id" {
  description = "ID of the project VPC"
  value       = module.networking.vpc_id
}

output "security_group_id" {
  description = "ID of the cluster security group"
  value       = module.networking.security_group_id
}

output "instance_public_ips" {
  description = "Public IPs of the EC2 instances (used for SSH access)"
  value       = module.compute.public_ips
}

output "aws_account_id" {
  description = "AWS account ID Terraform is currently authenticated as"
  value       = data.aws_caller_identity.current.account_id
}

output "topic_arn" {
    description = "ARN of the SNS alarms topic (consumed by modules/monitoring)"
    value = module.notifications.topic_arn
}