locals {
  team      = lookup(var.labels, "team", "")
  env       = lookup(var.labels, "env", "")
  component = lookup(var.labels, "component", "")
  extra_hosts = jsonencode(var.extra_hosts)
  sorted_application_secrets = [
    for k, v in var.application_secrets :
    {
      name      = k
      valueFrom = "arn:aws:secretsmanager:${var.platform_config["region"]}:${var.platform_config["account_id"]}:secret:${local.team}/${local.env}/${local.component}${v}::"
    }
  ]

  sorted_platform_secrets = [
    for k, v in var.platform_secrets :
    {
      name      = k
      valueFrom = "arn:aws:secretsmanager:${var.platform_config["region"]}:${var.platform_config["account_id"]}:secret:platform_secrets/${v}::"
    }
  ]

  final_secrets = flatten([local.sorted_application_secrets, local.sorted_platform_secrets])

}
    # Secrets currently look like
    # + name      = "DUMMY_AWS_SECRET"
    # + valueFrom = "arn:aws:secretsmanager:us-west-2:254076036999:secret:capplatformbsg/sfrazer-test/bsg-hello-world-ecs-example/DUMMY_AWS_SECRET-3OG3jI"



data "template_file" "container_definitions" {
  template = file("${path.module}/container_definition.json.tmpl")

  vars = {
    image                    = var.image
    container_name           = var.name
    port_mappings            = var.port_mappings == "" ? format("[ { \"containerPort\": %s } ]", var.container_port) : var.port_mappings
    cpu                      = var.cpu
    privileged               = var.privileged
    mem                      = var.memory    
    stop_timeout             = var.stop_timeout
    command                  = length(var.command) > 0 ? jsonencode(var.command) : "null"
    container_env            = data.external.encode_env.result["env"]
    secrets                  = local.final_secrets
    labels                   = jsonencode(var.labels)
    nofile_soft_ulimit       = var.nofile_soft_ulimit
    mountpoint_sourceVolume  = lookup(var.mountpoint, "sourceVolume", "none")
    mountpoint_containerPath = lookup(var.mountpoint, "containerPath", "none")
    mountpoint_readOnly      = lookup(var.mountpoint, "readOnly", false)
    extra_hosts              = local.extra_hosts == "[]" ? "null" : local.extra_hosts
  }
}

data "external" "encode_env" {
  program = ["python", "${path.module}/encode_env.py"]

  query = {
    env      = jsonencode(var.container_env)
    metadata = jsonencode(var.metadata)
  }
}

data "external" "encode_secrets" {
  program = ["python", "${path.module}/encode_secrets.py"]

  query = {
    secrets = jsonencode(
      zipmap(
        var.application_secrets,
        data.aws_secretsmanager_secret.secret.*.arn,
      ),
    )
    common_secrets = jsonencode(
      zipmap(
        var.platform_secrets,
        data.aws_secretsmanager_secret.platform_secrets.*.arn,
      ),
    )
  }
}

data "aws_secretsmanager_secret" "secret" {
  count = length(var.application_secrets)
  name  = "${local.team}/${local.env}/${local.component}/${element(var.application_secrets, count.index)}"
}

data "aws_secretsmanager_secret" "platform_secrets" {
  count = length(var.platform_secrets)
  name  = "platform_secrets/${element(var.platform_secrets, count.index)}"
}

