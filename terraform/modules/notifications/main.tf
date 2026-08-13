# SNS topic + email/SMS subscriptions for alarm delivery
resource "aws_sns_topic" "alarms" {
    name = "${var.project_name}-alarms"

    tags = {
        Name = "${var.project_name}-alarms"
        Project = var.project_name
    }
}

resource "aws_sns_topic_subscription" "email" {
    topic_arn = aws_sns_topic.alarms.arn
    protocol = "email"
    endpoint = var.alarm_email
}

resource "aws_sns_topic_subscription" "sms" {
    topic_arn = aws_sns_topic.alarms.arn
    protocol = "sms"
    endpoint = var.alarm_sms
}