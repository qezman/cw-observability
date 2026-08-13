# CloudWatch dashboard (one widget per metric type, each comparing all instances on one graph)
data "aws_region" "current" {}

locals {
    dashboard_body = {
        widgets = [
            {
                type = "metric"
                x   =   8
                y   =   0
                width = 8
                height = 6
                properties = {
                    title = "CPU Utilization"
                    view = "timeSeries"
                    region = data.aws_region.current.name
                    period = 60
                    stat = "Average"
                    metrics = [
                        for id in var.instance_ids : ["AWS/EC2", "CPUUtilization", "InstanceId", id, {label = id}]
                    ]
                }
            },

            {
                type = "metric"
                x   =   0
                y   =   0
                width = 8
                height = 6
                properties = {
                    title = "Memory Used %"
                    view = "timeSeries"
                    region = data.aws_region.current.name
                    period = 60
                    stat = "Average"
                    metrics = [
                        for id in var.instance_ids :
                        [var.project_name, "mem_used_percent", "InstanceId", id, {label = id}]
                    ]
                }
            },

            {
                type = "metric"
                x   =   16
                y   =   0
                width = 8
                height = 6
                properties = {
                    title = "Disk Used % (root volume)"
                    view = "timeSeries"
                    region = data.aws_region.current.name
                    period = 60
                    stat = "Average"
                    metrics = [
                        for id in var.instance_ids :
                        [var.project_name, "disk_used_percent", "InstanceId", id, "device", "nvme0n1p1", "fstype", "xfs", "path", "/", {label = id}]
                    ]
                }
            },

        ]
    }
}

resource "aws_cloudwatch_dashboard" "main" {
    dashboard_name = "${var.project_name}-dashboard"
    dashboard_body = jsonencode(local.dashboard_body)
}