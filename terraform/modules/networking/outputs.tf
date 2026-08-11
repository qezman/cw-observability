output "vpc_id" {
    description = "ID of the created VPC"
    value = aws_vpc.main.id
}

output "subnet_id" {
    description = "ID of the public subnet - consumed by modules/compute"
    value = aws_subnet.public.id
}

output "security_group_id" {
      description = "ID of the cluster security group - consumed by modules/compute"
    value = aws_security_group.cluster_sg.id
}