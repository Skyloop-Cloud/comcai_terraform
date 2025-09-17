# ECS Modülü Değişkenleri

variable "project_name" {
  description = "Proje adı"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private Subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security Group IDs"
  type        = list(string)
}

variable "target_group_arn" {
  description = "Target Group ARN"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR Repository URL"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}

variable "redis_endpoint" {
  description = "Redis Endpoint"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}


