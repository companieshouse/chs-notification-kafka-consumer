locals {
  subnet_az_map = { for subnet in data.aws_subnet.private_subnets :
    subnet.id => subnet.availability_zone
  }

  tags = merge(var.tags, {
    "Terraform" : "true"
    }
  )

  log_group_name = "cwg-${var.name}"

  lambda_file_name         = "lambda_function"
  lambda_package_file_name = "lambda_package.zip"
  lambda_function_name     = format("%s-%s-%02d", "lmba", var.name, 1)

  squid_cw_metrics = {
    procstats = [
      {
        pid = "/var/run/squid.pid"
        measurement = [
          "cpu_usage"
        ]
      }
    ]
    append_dimensions = [
      {
        option  = "AutoScalingGroupName"
        setting = "$${aws:AutoScalingGroupName}"
      }
    ]
    force_flush_interval = "5"
  }

  ansible_inputs = {
    cw_collect_metrics          = local.squid_cw_metrics
    metrics_collection_interval = 5
    cw_agent_user               = "root"
  }

  userdata_template_builtin = base64encode(templatefile("${path.module}/templates/user_data.tpl",
    {
      REGION         = data.aws_region.current.name
      ANSIBLE_INPUTS = jsonencode(local.ansible_inputs)
    }
  ))
}


