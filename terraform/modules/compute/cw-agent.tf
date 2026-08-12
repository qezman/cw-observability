# CloudWatch Agent config
resource "aws_ssm_parameter" "cw_agent_config" {
    name = "/${var.project_name}/cw-agent-config"
    type = "String"
    description = "CW Agent config - custom metrics (mem/disk/swap)"

  value = jsonencode({
    metrics = {
        namespace = var.project_name
        append_dimensions = {
            InstanceId = "$${aws:InstanceId}"
        }        
        metrics_collected = {
            mem = {
                measurement = ["mem_used_percent"]
            }
            disk = {
                measurement = ["disk_used_percent"]
                resources = ["/"]
            }
            swap = {
                measurement = ["swap_used_percent"]
            }
        }
    }
  })

  tags = {
    Name = "${var.project_name}-cw-agent-config"
    Project = var.project_name
  }
}

# Re-runs fetch-config against the current instances
resource "aws_ssm_document" "cw_agent_reconfig" {
    name = "${var.project_name}-cw-agent-reconfigure"
    document_type = "Command"
    document_format = "JSON"

    content = jsonencode({
    schemaVersion = "2.2"
    description   = "Re-fetch CW Agent config from SSM Parameter Store and restart the agent"
    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "fetchAndRestartCWAgent"
        inputs = {
          runCommand = [
            "/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:${aws_ssm_parameter.cw_agent_config.name}"
          ]
        }
      }
    ]
    })

    tags = {
    Name    = "${var.project_name}-cw-agent-reconfigure"
    Project = var.project_name
    }
}

resource "aws_ssm_association" "cw_agent_reconfig" {
    name = aws_ssm_document.cw_agent_reconfig.name

    targets {
        key = "InstanceIds"
        values = aws_instance.cluster[*].id
    }
}