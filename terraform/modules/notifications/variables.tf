variable "project_name" {
  description = "Name prefix used for tagging and resource naming"
  type        = string
}

variable "alarm_email" {
  description = "Email address to subscribe to SNS alarm notifications"
  type        = string
}

variable "alarm_sms" {
  description = "Phone number (E.164 format) to subscribe to SNS alarm notifications via SMS"
  type        = string
}