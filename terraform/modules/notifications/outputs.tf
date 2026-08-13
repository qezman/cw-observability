output "topic_arn" {
    description = "ARN of the SNS alarms topic (consumed by modules/monitoring)"
    value = aws_sns_topic.alarms.arn
}