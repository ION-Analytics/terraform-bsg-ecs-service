output "arn" {
  value = aws_ecs_task_definition.taskdef.arn
}

output "task_role_arn" {
  value = aws_iam_role.task_role.arn
}

output "task_role_name" {
  value = aws_iam_role.task_role.name
}

output "task_execution_role_arn" {
  value = aws_iam_role.ecs_tasks_execution_role.arn
}

output "task_execution_role_name" {
  value = aws_iam_role.ecs_tasks_execution_role.name
}

