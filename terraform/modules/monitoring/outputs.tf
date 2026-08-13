output "disk_alarm_arns" {
    description = "ARNs of the disk usage alarms"
    value = aws_cloudwatch_metric_alarm.disk_high[*].arn
}

output "cpu_alarm_arns" {
    description = "ARNs of the CPU usage alarms"
    value = aws_cloudwatch_metric_alarm.cpu_high[*].arn
}

output "mem_alarm_arns" {
    description = "ARNs of the memory usage alarms"
    value = aws_cloudwatch_metric_alarm.mem_high[*].arn
}