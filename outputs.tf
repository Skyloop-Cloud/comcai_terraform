# Comcai Tam Mimari Çıktıları

# API Gateway Çıktıları
output "api_gateway_url" {
  description = "API Gateway URL"
  value       = module.api_gateway.api_url
}

output "api_gateway_id" {
  description = "API Gateway ID"
  value       = module.api_gateway.api_id
}

# VPC Çıktıları
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

# GitHub Actions IAM Role
output "github_actions_role_arn" {
  description = "GitHub Actions IAM Role ARN"
  value       = module.iam.github_actions_role_arn
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# ALB Çıktıları
output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "ALB Zone ID"
  value       = module.alb.alb_zone_id
}

# ECS Çıktıları
output "ecs_cluster_name" {
  description = "ECS Cluster Name"
  value       = module.ecs.cluster_name
}

output "ecs_cluster_arn" {
  description = "ECS Cluster ARN"
  value       = module.ecs.cluster_arn
}

output "ecs_service_name" {
  description = "ECS Service Name"
  value       = module.ecs.service_name
}

# ECR Çıktıları
output "ecr_repository_url" {
  description = "ECR Repository URL"
  value       = module.ecr.repository_url
}

output "ecr_repository_name" {
  description = "ECR Repository Name"
  value       = module.ecr.repository_name
}

# S3 Çıktıları
output "s3_bucket_name" {
  description = "S3 Bucket Name"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "S3 Bucket ARN"
  value       = module.s3.bucket_arn
}

# ElastiCache Çıktıları
output "redis_endpoint" {
  description = "Redis Endpoint"
  value       = module.elasticache.redis_endpoint
}

output "redis_port" {
  description = "Redis Port"
  value       = module.elasticache.redis_port
}