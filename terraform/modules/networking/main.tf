# networking.tf
# VPC + public subnet + internet gateway + security group for the monitored EC2 cluster

# dedicated VPC so this project is fully isolated and cleanly destroyable
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.project_name}-vpc"
        Project = var.project_name
    }
}

# public subnet (instances need outbound internet to reach the CloudWatch/SSM endpoints)
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
        Name = "${var.project_name}-public-subnet"
        Project = var.project_name
  }
}

# Internet gateway (required for the subnet's route table to reach the internet)
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.project_name}-igw"
  }
}

# Route table sending all outbound traffic (0.0.0.0/0) through the IGW
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "${var.project_name}-public-rt"
    }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

# Security group: SSH restricted to admin IP, all outbound allowed
# (needed for CW Agent + SSM agent to reach AWS endpoints)
resource "aws_security_group" "cluster_sg" {
    name = "${var.project_name}-sg"
    description = "Allow SSH from a trusted CIDR, allow all outbound"
    vpc_id = aws_vpc.main.id

    ingress {
        description = "SSH from trusted IP only"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.ssh_allowed_cidr]
    }

    egress {
        description = "Allow all outbound (CW/SSM endpoints, package repos)"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

        tags = {
        Name = "${var.project_name}-sg"
        Project = var.project_name
    }
}
