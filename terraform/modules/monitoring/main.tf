# One disk/CPU/memory alarm per instance, all notifying through the shared SNS topic

resource "aws_cloudwatch_metric_alarm" "disk_high" {
    count = length(var.instance_ids)

    alarm_name = "${var.project_name}-disk-high-${count.index+1}"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods   = 3
    metric_name          = "disk_used_percent"
    namespace            = var.project_name
    period               = 60
    statistic            = "Average"
    threshold            = var.disk_threshold
    alarm_description    = "Disk usage above ${var.disk_threshold}% on instance ${count.index + 1}"
    alarm_actions        = [var.sns_topic_arn]
    ok_actions            = [var.sns_topic_arn]

    dimensions = {
        InstanceId = var.instance_ids[count.index]
        path = "/"
    }

    tags = {
        Name = "${var.project_name}-disk-high-${count.index+1}"
        Project = var.project_name
    }
}

# CPU spike alarm
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
    count = length(var.instance_ids)

    alarm_name = "${var.project_name}-cpu-high-${count.index+1}"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods   = 3
    metric_name          = "CPUUtilization"
    namespace            = "AWS/EC2"
    period               = 60
    statistic            = "Average"
    threshold            = var.cpu_threshold
    alarm_description    = "CPU usage above ${var.cpu_threshold}% on instance ${count.index + 1}"
    alarm_actions        = [var.sns_topic_arn]
    ok_actions           = [var.sns_topic_arn]

    dimensions = {
        InstanceId = var.instance_ids[count.index]
    }

    tags = {
        Name = "${var.project_name}-cpu-high-${count.index+1}"
        Project = var.project_name
    }
}

# Memory usage alarm
resource "aws_cloudwatch_metric_alarm" "mem_high" {
    count = length(var.instance_ids)

    alarm_name = "${var.project_name}-mem_high-${count.index+1}"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods   = 3
    metric_name          = "mem_used_percent"
    namespace            = var.project_name
    period               = 60
    statistic            = "Average"
    threshold            = var.mem_threshold
    alarm_description    = "Memory usage above ${var.mem_threshold}% on instance ${count.index + 1}"
    alarm_actions        = [var.sns_topic_arn]
    ok_actions           = [var.sns_topic_arn]

    dimensions = {
        InstanceId = var.instance_ids[count.index]
    }

    tags = {
        Name = "${var.project_name}-mem-high-${count.index+1}"
        Project = var.project_name
    }
}