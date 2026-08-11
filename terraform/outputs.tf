output "vpc_id" {
  description = "ID of the project VPC"
  value       = module.networking.vpc_id
}

output "security_group_id" {
  description = "ID of the cluster security group"
  value       = module.networking.security_group_id
}