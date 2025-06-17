// ECS module outputs
output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs-cluster.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs-cluster.name
}

output "ecs_cluster_sg_id" {
  value = aws_security_group.ec2-security-group.id
}

output "ecs_cluster_autoscalinggroup_arn" {
  value = aws_autoscaling_group.ecs-autoscaling-group.arn
}

// IAM module outputs

output "ecs_instance_profile_name" {
  value = aws_iam_instance_profile.ecs-instance-profile.name
}

output "ecs_instance_role_name" {
  value = aws_iam_role.ecs-instance-role.name
}

output "ecs_service_role_arn" {
  value = aws_iam_role.ecs-service-role.arn
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs-task-execution-role.arn
}
