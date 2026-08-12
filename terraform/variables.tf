variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix for tagging and resource naming across all modules"
  type        = string
  default     = "cw-observability"
}

variable "instance_count" {
  description = "Number of EC2 instances in monitored cluster"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "EC2 instance type for the cluster"
  type        = string
  default     = "t3.micro"
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to SSH into instances (admin IP/32)"
  type        = string
  # No default - forces admin to set this explicitly so SSH is never left open
}

variable "alarm_email" {
  description = "Email address to subscribe to SNS alarm notifications"
  type        = string
}

variable "alarm_sms" {
  description = "Phone number (E.164 format, e.g. +15555550123) to subscribe to SNS alarm notifications via SMS"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the project VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zone" {
  description = "AZ to deploy the subnet into"
  type        = string
  default     = "us-east-1a"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair in AWS (used for SSH access)"
  type        = string
} 