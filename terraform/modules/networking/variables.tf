variable "project_name" {
    description = "Name prefix used for tagging and resource naming"
    type = string
}

variable "vpc_cidr" {
    description = "CIDR block for the project VPC"
    type = string
}

variable "public_subnet_cidr" {
    description = "CIDR block for the public subnet"
    type = string
}

variable "availability_zone" {
    description = "AZ to deploy the subnet into"
    type = string
}

variable "ssh_allowed_cidr" {
    description = "CIDR block allowed to SSH into instances (admin IP/32)"
    type = string
}