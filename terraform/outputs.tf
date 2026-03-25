# Outputs - values shown after terraform apply
# Like console.log() but for Terraform!

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app.name
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.app.id
}
