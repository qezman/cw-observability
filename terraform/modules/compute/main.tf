# EC2 instances for the monitored cluster (scalable via instance_count)

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 instances 
resource "aws_instance" "cluster" {
    count = var.instance_count

    ami = data.aws_ami.al2023.id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    vpc_security_group_ids = [var.security_group_id]
    iam_instance_profile = var.instance_profile_name
    key_name = var.key_name

     # Bootstrap placeholder
      user_data = <<-EOF
      #!/bin/bash
      yum update -y
      yum install -y amazon-cloudwatch-agent
      /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:${aws_ssm_parameter.cw_agent_config.name}
      EOF

     tags = {
        Name = "${var.project_name}-instance-${count.index + 1}"
        Project = var.project_name
     }
}

# static public IP per instance
resource "aws_eip" "cluster" {
  count = var.instance_count
  instance = aws_instance.cluster[count.index].id
  domain = "vpc"

  tags = {
    Name    = "${var.project_name}-eip-${count.index + 1}"
    Project = var.project_name
  }
}