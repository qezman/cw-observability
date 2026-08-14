---
title: Phase 2 - CloudWatch Agent
nav_order: 3
---

**Resources:** SSM Parameter (CW Agent JSON config), SSM Document (Command type), SSM Association targeting both instances.

**Configuration:**

- Custom metrics collected: `mem_used_percent`, `disk_used_percent`, `swap_used_percent`.
- Config stored once in SSM Parameter Store, read via `amazon-cloudwatch-agent-ctl -c ssm:<param-name>` - same source used by `user_data` at first boot and by the SSM Association for later re-application to running instances without replacement.

**Issues/fixes:**

- Default AWS CLI profile pointed at an unrelated AWS account; all CLI calls for this project require `--profile cw-observability` / `AWS_PROFILE=cw-observability`.

**Verification:** `aws cloudwatch list-metrics --namespace <project_name>` confirmed all three custom metrics present with correct `InstanceId` dimensions.