---
title: Phase 1 - Networking, IAM, Compute
nav_order: 2
---

**Resources:** VPC (10.0.0.0/16), 1 public subnet, IGW, route table, security group (SSH/22 restricted to admin CIDR, all outbound), IAM role + instance profile, EC2 instances (count-based), Elastic IPs.

**Configuration:**

- `map_public_ip_on_launch = false` on the subnet; public IPs assigned only via explicit `aws_eip` resources per instance, not subnet default.
- AMI resolved via `data "aws_ami"` (latest AL2023), not hardcoded.
- IAM role trust policy scoped to `ec2.amazonaws.com` only. Policies attached: `CloudWatchAgentServerPolicy`, `AmazonSSMManagedInstanceCore`.
- Two-file variable pattern: `terraform.tfvars` (committed, non-sensitive) / `secrets.tfvars` (gitignored). `ssh_allowed_cidr` placeholder in the committed file is intentionally an invalid CIDR, so `plan`/`apply` fails if `secrets.tfvars` isn't supplied.

**Issues/fixes:**

- SSH key path used a Windows path (`C:\Users\...`) from WSL; fixed by copying key into `~/.ssh/` (WSL filesystem), `chmod 400`.

**Verification:** `terraform apply`, SSH connectivity confirmed to both instances.