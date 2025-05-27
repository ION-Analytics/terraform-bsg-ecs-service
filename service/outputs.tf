output "name" {
  value = join(
    "",
    compact(
      concat(
        aws_ecs_service.service.*.name,
        aws_ecs_service.service_no_loadbalancer.*.name,
        aws_ecs_service.service_for_awsvpc_no_loadbalancer.*.name,
        aws_ecs_service.service_multiple_loadbalancers.*.name,
      )
    )
  )
}
