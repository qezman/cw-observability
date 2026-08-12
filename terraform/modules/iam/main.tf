# EC2 instance role + instance profile granting CloudWatch Agent + SSM access

# trust policy: only the EC2 service can assume this role
data "aws_iam_policy_document" "ec2_assume_role" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]

        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

# role the EC2 instances assume to push custom metrics + accept SSM commands
resource "aws_iam_role" "ec2_role" {
    name = "${var.project_name}-ec2-role"
    assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

    tags = {
        Name = "${var.project_name}-ec2-role"
        Project = var.project_name
    }
}

# grants permission to push custom metrics (mem/disk/swap) to CloudWatch
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
    role = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# grants SSM Session Manager + run command access (enables config pushes without SSH)
resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
    role = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# instance profile - the object EC2 actually attaches, wraps the role
resource "aws_iam_instance_profile" "ec2_profile" {
    name = "${var.project_name}-ec2-profile"
    role = aws_iam_role.ec2_role.name

    tags = {
        Name = "${var.project_name}-ec2-profile"
        Project = var.project_name
    }
}