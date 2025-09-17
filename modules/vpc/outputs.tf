# VPC Modülü Çıktıları

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.main.id
}

output "alb_sg_id" {
  description = "ALB Security Group ID"
  value       = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  description = "ECS Security Group ID"
  value       = aws_security_group.ecs_sg.id
}

output "elasticache_sg_id" {
  description = "ElastiCache Security Group ID"
  value       = aws_security_group.elasticache_sg.id
}

