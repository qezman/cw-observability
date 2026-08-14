---
title: Phase 5 - Validation
nav_order: 6
---

**Actions:** Real-load stress testing (CPU, memory - see Phase 3). Disk alarm not independently load-tested: root volume is 30GB, reaching 80% used from a ~14% baseline requires writing ~21GB of filler data, judged disproportionate risk/effort given the alarm mechanism was already validated twice via CPU/memory. README, architecture diagram, and this document produced. `terraform destroy` executed and confirmed clean removal of all resources.

## Module Wiring


| Output                                              | Consumed by         |
| --------------------------------------------------- | ------------------- |
| `module.networking.subnet_id`, `.security_group_id` | `module.compute`    |
| `module.iam.instance_profile_name`                  | `module.compute`    |
| `module.compute.instance_ids`                       | `module.monitoring` |
| `module.notifications.topic_arn`                    | `module.monitoring` |


Root `main.tf` contains only `module` blocks - no bare resources, no direct references into child module resources (all cross-module data flows through declared outputs).
