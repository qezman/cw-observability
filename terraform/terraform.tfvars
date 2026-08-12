aws_region         = "us-east-1"
project_name       = "cw-observability"
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
availability_zone  = "us-east-1a"
# ssh_allowed_cidr   = "REPLACE_WITH_ADMIN_IP/32"
key_name = "cw-kp"

# NB:
# export ssh_allowed_cidr="102.89.76.85"
# echo $ssh_allowed_cidr