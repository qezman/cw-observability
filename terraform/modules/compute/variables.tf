variable "project_name" {
  description = "Name prefix used for tagging and resource naming"
  type = string
}

variable "instance_type" {
    description = "EC2 instance type fot the cluster"
    type = string
}

variable "instance_count" {
    description = "Number of EC2 instances to launch"
    type = number
}

variable "subnet_id" {
  description = "Public subnet ID to launch instances into"
  type = string
}

variable "security_group_id" {
    description = "Security group ID to attach"
    type = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name to attach"
  type        = string
}

variable "key_name" {
  description = "Name of an existing EC2 key pair in AWS (used for SSH access)"
  type        = string
} 