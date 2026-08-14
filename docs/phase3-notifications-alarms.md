---
title: Phase 3 - Notifications & Alarms
nav_order: 4
---

**Resources:** SNS topic, email subscription, SMS subscription, 6 CloudWatch alarms (disk/CPU/memory × 2 instances).

**Configuration:**

- Alarm period 60s, evaluation_periods 3 (3-minute sustained breach). `alarm_actions`/`ok_actions` both point at the SNS topic ARN.
- CPU alarm requires EC2 detailed monitoring (`monitoring = true`) - basic monitoring only publishes `CPUUtilization` at 5-minute resolution, which doesn't align with a 60s alarm period.

**Issues/fixes:**

- All 6 alarms initially used `dimensions = { instanceId = ... }` (lowercase). CloudWatch dimension names are case-sensitive; real metrics publish under `InstanceId`. Alarms were syntactically valid, applied without error, and remained permanently in `INSUFFICIENT_DATA`. Found by cross-referencing `describe-alarms` output against `get-metric-statistics` data during load testing. Fixed by correcting the dimension key.
- SMS subscription auto-confirms but delivery is blocked by AWS's default SNS SMS account spending quota. Not resolved (would require an AWS Support quota-increase request); documented as a known limitation.

**Verification:** Manual trigger (`aws cloudwatch set-alarm-state`) confirmed email delivery. Real-load trigger (`stress-ng --cpu 2`, `stress-ng --vm 1 --vm-bytes 85%`) confirmed both CPU and memory alarms fire and recover correctly post-fix.