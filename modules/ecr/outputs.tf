# ECR Modülü Çıktıları

output "repository_url" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.main.repository_url
}

output "repository_name" {
  description = "ECR Repository Name"
  value       = aws_ecr_repository.main.name
}

output "repository_arn" {
  description = "ECR Repository ARN"
  value       = aws_ecr_repository.main.arn
}

output "registry_id" {
  description = "ECR Registry ID"
  value       = aws_ecr_repository.main.registry_id
}


