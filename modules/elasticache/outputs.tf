# ElastiCache Modülü Çıktıları

output "redis_endpoint" {
  description = "Redis Primary Endpoint"
  value       = aws_elasticache_replication_group.main.primary_endpoint_address
}

output "redis_port" {
  description = "Redis Port"
  value       = aws_elasticache_replication_group.main.port
}

output "redis_reader_endpoint" {
  description = "Redis Reader Endpoint"
  value       = aws_elasticache_replication_group.main.reader_endpoint_address
}

output "redis_replication_group_id" {
  description = "Redis Replication Group ID"
  value       = aws_elasticache_replication_group.main.replication_group_id
}

output "redis_arn" {
  description = "Redis ARN"
  value       = aws_elasticache_replication_group.main.arn
}


