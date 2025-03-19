resource "aws_ecs_task_definition" "taskdef" {
  family                = var.family
  container_definitions = var.container_definitions
  task_role_arn         = var.task_role_arn
  execution_role_arn    = var.execution_role_arn
  network_mode          = var.network_mode
  tags                  = var.tags

  volume {
    name      = lookup(var.volume, "name", "dummy")
    host_path = lookup(var.volume, "host_path", "/tmp/dummy_volume")
  }
  dynamic "placement_constraints" {
    for_each = var.placement_constraint_on_demand_only == true ? [1] : []
    content {
        type       =  "memberOf"
        expression = "attribute:lifecycle == on-demand" 
    }
  }
}
