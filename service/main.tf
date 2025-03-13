resource "aws_ecs_service" "service" {

  name                               = var.name
  cluster                            = var.cluster
  task_definition                    = var.task_definition
  desired_count                      = var.desired_count
  iam_role                           = aws_iam_role.role.arn
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  enable_execute_command             = true

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }
  
  ordered_placement_strategy {
    type  = lower(var.pack_and_distinct) == "true" ? "binpack" : "spread"
    field = lower(var.pack_and_distinct) == "true" ? "cpu" : "instanceId"
  }

  placement_constraints {
    type = lower(var.pack_and_distinct) == "true" ? "distinctInstance" : "memberOf"
    expression = lower(var.pack_and_distinct) == "true" ? "" : "agentConnected == true"
  }

  dynamic capacity_provider_strategy {
    for_each = var.capacity_providers
    content {
      base = 0
      capacity_provider = capacity_provider_strategy.value["capacity_provider"]
      weight = capacity_provider_strategy.value["weight"]
    }
  }

  force_new_deployment = true  
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      ordered_placement_strategy,
    ]
  }
}
