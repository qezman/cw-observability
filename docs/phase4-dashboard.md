---
title: Phase 4 - Dashboard
nav_order: 5
---

**Resources:** 1 CloudWatch dashboard, 3 widgets (CPU, memory, disk).

**Configuration:**

- Each widget plots both instances on one graph (not one widget per instance per metric).
- Disk widget dimensions hardcode `device=nvme0n1p1`, `fstype=xfs` - valid only because both instances are identical `t3.micro`/AL2023 with a single root volume.

**Verification:** Applied, dashboard rendered with live data on all three widgets, screenshotted.