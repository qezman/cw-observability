# cw-observability

A modular Terraform project provisioning a small monitored EC2 cluster on AWS: custom CloudWatch metrics (memory, disk, swap) via the CloudWatch Agent, CPU/memory/disk alarms, and SNS-based alerting. See "Design Decisions & Trade-offs" below for the reasoning behind each choice, not just the what.

## Architecture

![Architecture diagram](./architecture.gif)

## Module structure

```
terraform/
├── main.tf, variables.tf, outputs.tf, provider.tf   # root orchestration layer only
├── terraform.tfvars      # non-sensitive values, committed
├── secrets.tfvars         # sensitive values, gitignored
└── modules/
    ├── networking/    # VPC, subnet, IGW, route table, security group
    ├── iam/           # EC2 role + instance profile
    ├── compute/       # EC2 instances, EIPs, CW Agent bootstrap + SSM config management
    ├── notifications/ # SNS topic + email/SMS subscriptions
    └── monitoring/     # CloudWatch alarms + dashboard
```



## Prerequisites

- Terraform >= 1.5.0
- An AWS account and an IAM user (`cw-deployer` in this project) with EC2, IAM, SSM, SNS, and CloudWatch permissions
- An EC2 key pair already created in your target region (private key stored locally, e.g. `~/.ssh/cw-kp.pem`, never committed)



## Setup

1. Configure AWS credentials: `aws configure --profile cw-observability`
2. Copy `terraform.tfvars` and fill in your real values in `secrets.tfvars` (see below)
3. `terraform init`
4. `terraform plan -var-file="terraform.tfvars" -var-file="secrets.tfvars"`
5. `terraform apply -var-file="terraform.tfvars" -var-file="secrets.tfvars"`



### Variables


| File                           | Contents                                                                                                                          |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- |
| `terraform.tfvars` (committed) | `aws_region`, `project_name`, `vpc_cidr`, `public_subnet_cidr`, `availability_zone`, `ssh_allowed_cidr` (placeholder), `key_name` |
| `secrets.tfvars` (gitignored)  | `ssh_allowed_cidr` (your real IP, overrides the placeholder), `alarm_email`, `alarm_sms`                                          |


Your public IP changes if your ISP assigns dynamically - check `curl ifconfig.me` before each `plan`/`apply` and update `secrets.tfvars` accordingly, or SSH access will silently fail.

## Verification performed

- SSH connectivity confirmed to both instances post-apply
- Custom metrics (`mem_used_percent`, `disk_used_percent`, `swap_used_percent`) confirmed live in CloudWatch under the `cw-observability` namespace via `aws cloudwatch list-metrics`
- CPU and memory alarms triggered under real load (`stress-ng`) and confirmed email + SMS delivery end-to-end
- Dashboard confirmed rendering all three widgets (CPU/memory/disk) with both instances' data



## Design decisions & trade-offs

- **Public subnet, no NAT Gateway** - cost-conscious choice for a demo cluster. In production this would be a private subnet with a NAT Gateway, or SSM Session Manager only with zero public IPs.
- **Explicit EIPs,** `map_public_ip_on_launch = false` **at the subnet level** - no implicit public IP assignment; every public-facing IP is an explicit, auditable Terraform resource rather than a subnet-level default.
- **AWS managed IAM policies** (`CloudWatchAgentServerPolicy`, `AmazonSSMManagedInstanceCore`) rather than a custom least-privilege policy - faster to stand up, broader than strictly necessary; a production version would scope this down.
- **CW Agent config in SSM Parameter Store**, referenced by both the initial `user_data` bootstrap and a Terraform-managed SSM association - single source of truth, lets you push config changes to already-running instances without replacing them.
- **No swap configured** on the instances - AL2023 default; `swap_used_percent` reports but stays near 0. Would need an explicit swapfile in `user_data` to make this metric meaningful.
- **SMS delivery not fully validated** - the subscription auto-confirms and is correctly wired to the SNS topic, but AWS's default SNS SMS spending quota blocked actual delivery in testing. Email delivery was fully confirmed end-to-end instead; resolving SMS would require an AWS Support quota-increase request, not pursued for this demo.
- **Disk alarm not independently load-tested** - validated via the same corrected alarm configuration and dimension wiring proven twice over by the CPU and memory alarms, but not physically triggered, since the root volume is large enough (30GB) that reproducing an 80%+ fill would mean writing ~21GB of filler data - disproportionate risk/effort for marginal additional proof.
- **CloudWatch alarm periods set to 60s/3 evaluation periods** rather than the more common 300s production default - deliberate for fast feedback during testing. EC2's `CPUUtilization` alarm required enabling detailed monitoring (`monitoring = true`) to actually publish at 1-minute granularity; without it, basic monitoring's 5-minute native resolution made the 60s-period alarm effectively unable to evaluate correctly.

## Teardown

```bash
terraform destroy -var-file="terraform.tfvars" -var-file="secrets.tfvars"
```

Confirms removal of all 24 resources (VPC, subnet, IGW, route table, security group, IAM role/profile, 2x EC2 instances, 2x EIPs, SSM parameter/document/association, SNS topic/subscriptions, CloudWatch alarms x6, dashboard). No resources are excluded from destroy - this project has no S3 buckets, RDS instances, or anything else requiring manual deletion protection removal first.