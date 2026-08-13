variable "project_name" {
  description = "Name prefix used for tagging and resource naming"
  type        = string
}

variable "instance_ids" {
  description = "IDs of the EC2 instances to alarm on (from modules/compute)"
  type        = list(string)
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic to notify on alarm state changes (from modules/notifications)"
  type        = string
}

variable "disk_threshold" {
  description = "Disk used percent threshold that triggers the alarm"
  type        = number
  default     = 80
}

variable "cpu_threshold" {
  description = "CPU utilization percent threshold that triggers the alarm"
  type        = number
  default     = 80
}

variable "mem_threshold" {
  description = "Memory used percent threshold that triggers the alarm"
  type        = number
  default     = 80
}
